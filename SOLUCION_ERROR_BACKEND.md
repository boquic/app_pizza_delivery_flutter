# 🔧 Solución: Error 500 en /api/usuario/carrito

## ❌ Problema

El backend está lanzando un error 500:
```
java.lang.NullPointerException: Cannot invoke "org.springframework.security.core.Authentication.getName()" because "authentication" is null
```

## 🔍 Causa

El `SecurityContextHolder` no está configurando correctamente la autenticación a partir del token JWT.

El token se está enviando correctamente desde el frontend:
```
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
```

Pero el backend no está procesando este token para crear el objeto `Authentication`.

## ✅ Solución en el Backend

### 1. Verificar el JwtAuthenticationFilter

Asegúrate de que tu filtro JWT esté configurado correctamente:

```java
@Component
public class JwtAuthenticationFilter extends OncePerRequestFilter {

    @Autowired
    private JwtService jwtService;

    @Autowired
    private UserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(
            HttpServletRequest request,
            HttpServletResponse response,
            FilterChain filterChain
    ) throws ServletException, IOException {
        
        final String authHeader = request.getHeader("Authorization");
        final String jwt;
        final String userEmail;

        // Verificar que el header existe y tiene el formato correcto
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            filterChain.doFilter(request, response);
            return;
        }

        // Extraer el token
        jwt = authHeader.substring(7);
        
        try {
            // Extraer el email del token
            userEmail = jwtService.extractUsername(jwt);

            // Si el email existe y no hay autenticación en el contexto
            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                
                // Cargar los detalles del usuario
                UserDetails userDetails = this.userDetailsService.loadUserByUsername(userEmail);

                // Validar el token
                if (jwtService.isTokenValid(jwt, userDetails)) {
                    
                    // Crear el objeto de autenticación
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            null,
                            userDetails.getAuthorities()
                    );
                    
                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request)
                    );
                    
                    // IMPORTANTE: Establecer la autenticación en el contexto
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                }
            }
        } catch (Exception e) {
            // Log del error pero continuar con el filtro
            System.err.println("Error procesando JWT: " + e.getMessage());
        }

        filterChain.doFilter(request, response);
    }
}
```

### 2. Verificar la Configuración de Security

Asegúrate de que el filtro esté registrado correctamente:

```java
@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Autowired
    private JwtAuthenticationFilter jwtAuthFilter;

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
            .csrf(csrf -> csrf.disable())
            .authorizeHttpRequests(auth -> auth
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/pizzas/**").permitAll()
                .anyRequest().authenticated()
            )
            .sessionManagement(session -> session
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            )
            // IMPORTANTE: Agregar el filtro JWT antes del filtro de autenticación
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
```

### 3. Verificar el Controller

El controller debe obtener la autenticación del contexto:

```java
@RestController
@RequestMapping("/api/usuario")
public class CarritoController {

    @Autowired
    private CarritoService carritoService;

    @GetMapping("/carrito")
    public ResponseEntity<CarritoModel> obtenerCarrito() {
        // Obtener la autenticación del contexto de seguridad
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        
        // Verificar que la autenticación no sea null
        if (authentication == null || !authentication.isAuthenticated()) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        // Obtener el email del usuario autenticado
        String email = authentication.getName();
        
        // Obtener el carrito
        CarritoModel carrito = carritoService.obtenerCarritoPorUsuario(email);
        
        return ResponseEntity.ok(carrito);
    }

    // Alternativa: Usar @AuthenticationPrincipal
    @GetMapping("/carrito-v2")
    public ResponseEntity<CarritoModel> obtenerCarritoV2(
            @AuthenticationPrincipal UserDetails userDetails
    ) {
        if (userDetails == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        
        String email = userDetails.getUsername();
        CarritoModel carrito = carritoService.obtenerCarritoPorUsuario(email);
        
        return ResponseEntity.ok(carrito);
    }
}
```

## 🧪 Verificar la Solución

### 1. Probar con Postman

```bash
# Login
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "email": "juan@example.com",
  "password": "password123"
}

# Copiar el token de la respuesta

# Obtener carrito
GET http://localhost:8080/api/usuario/carrito
Authorization: Bearer {TOKEN_AQUI}
```

### 2. Verificar Logs

Agrega logs en el filtro JWT para debug:

```java
@Override
protected void doFilterInternal(...) {
    System.out.println("=== JWT Filter ===");
    System.out.println("Auth Header: " + authHeader);
    System.out.println("JWT: " + jwt);
    System.out.println("User Email: " + userEmail);
    System.out.println("Authentication: " + SecurityContextHolder.getContext().getAuthentication());
    System.out.println("==================");
    
    // ... resto del código
}
```

## 📱 Frontend (Ya está correcto)

El frontend ya está enviando el token correctamente:

```dart
// En DioClient
_dio.interceptors.add(
  InterceptorsWrapper(
    onRequest: (options, handler) {
      if (authStorage != null) {
        final token = authStorage!.getToken();
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
      }
      return handler.next(options);
    },
  ),
);
```

## ✅ Checklist de Verificación

- [ ] JwtAuthenticationFilter implementado correctamente
- [ ] Filtro registrado en SecurityConfig
- [ ] Filtro se ejecuta ANTES de UsernamePasswordAuthenticationFilter
- [ ] JwtService extrae correctamente el username del token
- [ ] UserDetailsService carga el usuario correctamente
- [ ] SecurityContextHolder.getContext().setAuthentication() se llama
- [ ] Controller obtiene la autenticación del contexto
- [ ] Endpoints protegidos requieren autenticación

## 🔄 Flujo Correcto

```
1. Frontend envía request con token JWT
   ↓
2. JwtAuthenticationFilter intercepta el request
   ↓
3. Extrae el token del header Authorization
   ↓
4. Valida el token con JwtService
   ↓
5. Carga UserDetails con UserDetailsService
   ↓
6. Crea UsernamePasswordAuthenticationToken
   ↓
7. Establece la autenticación en SecurityContextHolder
   ↓
8. Controller obtiene la autenticación del contexto
   ↓
9. Procesa el request y retorna respuesta
```

## 🚨 Errores Comunes

### 1. Filtro no registrado
```java
// ❌ Incorrecto
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) {
    // Falta agregar el filtro
    return http.build();
}

// ✅ Correcto
@Bean
public SecurityFilterChain securityFilterChain(HttpSecurity http) {
    http.addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);
    return http.build();
}
```

### 2. No establecer la autenticación
```java
// ❌ Incorrecto
if (jwtService.isTokenValid(jwt, userDetails)) {
    // Crear el token pero no establecerlo
    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(...);
}

// ✅ Correcto
if (jwtService.isTokenValid(jwt, userDetails)) {
    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(...);
    SecurityContextHolder.getContext().setAuthentication(authToken); // IMPORTANTE
}
```

### 3. Verificar autenticación incorrectamente
```java
// ❌ Incorrecto
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
String email = auth.getName(); // NullPointerException si auth es null

// ✅ Correcto
Authentication auth = SecurityContextHolder.getContext().getAuthentication();
if (auth == null || !auth.isAuthenticated()) {
    throw new UnauthorizedException("Usuario no autenticado");
}
String email = auth.getName();
```

## 📞 Soporte

Si el problema persiste después de aplicar estas soluciones:

1. Verifica los logs del backend
2. Agrega breakpoints en el JwtAuthenticationFilter
3. Verifica que el token no haya expirado
4. Verifica que el secret key sea el mismo para generar y validar tokens

---

**Nota**: El frontend está funcionando correctamente. El problema es exclusivamente del backend y debe ser resuelto allí.
