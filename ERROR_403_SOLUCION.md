# 🔴 Error 403 Forbidden - Solución Urgente

## ❌ Problema Actual

El backend está retornando **403 Forbidden** en todas las peticiones autenticadas:
- `POST /api/carrito/agregar` → 403
- `GET /api/usuario/carrito` → 403

## 🔍 Causa Raíz

El **JwtAuthenticationFilter** en el backend NO está procesando correctamente el token JWT, por lo que Spring Security está rechazando las peticiones.

## ✅ Solución en el Backend (URGENTE)

### Paso 1: Verificar que el filtro JWT esté registrado

En `SecurityConfig.java`:

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
            // ⚠️ CRÍTICO: Agregar el filtro JWT
            .addFilterBefore(jwtAuthFilter, UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }
}
```

### Paso 2: Implementar correctamente el JwtAuthenticationFilter

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
        
        // Log para debug
        System.out.println("=== JWT Filter Debug ===");
        System.out.println("Path: " + request.getRequestURI());
        System.out.println("Auth Header: " + authHeader);
        
        if (authHeader == null || !authHeader.startsWith("Bearer ")) {
            System.out.println("No JWT token found");
            filterChain.doFilter(request, response);
            return;
        }

        try {
            final String jwt = authHeader.substring(7);
            final String userEmail = jwtService.extractUsername(jwt);
            
            System.out.println("JWT Token: " + jwt.substring(0, 20) + "...");
            System.out.println("User Email: " + userEmail);

            if (userEmail != null && SecurityContextHolder.getContext().getAuthentication() == null) {
                
                UserDetails userDetails = this.userDetailsService.loadUserByUsername(userEmail);
                
                if (jwtService.isTokenValid(jwt, userDetails)) {
                    
                    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                            userDetails,
                            null,
                            userDetails.getAuthorities()
                    );
                    
                    authToken.setDetails(
                            new WebAuthenticationDetailsSource().buildDetails(request)
                    );
                    
                    // ⚠️ CRÍTICO: Establecer la autenticación
                    SecurityContextHolder.getContext().setAuthentication(authToken);
                    
                    System.out.println("Authentication set successfully for: " + userEmail);
                } else {
                    System.out.println("Token is not valid");
                }
            }
        } catch (Exception e) {
            System.err.println("Error in JWT filter: " + e.getMessage());
            e.printStackTrace();
        }
        
        System.out.println("========================");
        filterChain.doFilter(request, response);
    }
}
```

### Paso 3: Verificar el JwtService

```java
@Service
public class JwtService {

    @Value("${jwt.secret}")
    private String SECRET_KEY;

    public String extractUsername(String token) {
        return extractClaim(token, Claims::getSubject);
    }

    public <T> T extractClaim(String token, Function<Claims, T> claimsResolver) {
        final Claims claims = extractAllClaims(token);
        return claimsResolver.apply(claims);
    }

    private Claims extractAllClaims(String token) {
        return Jwts
                .parserBuilder()
                .setSigningKey(getSignInKey())
                .build()
                .parseClaimsJws(token)
                .getBody();
    }

    public boolean isTokenValid(String token, UserDetails userDetails) {
        final String username = extractUsername(token);
        return (username.equals(userDetails.getUsername())) && !isTokenExpired(token);
    }

    private boolean isTokenExpired(String token) {
        return extractExpiration(token).before(new Date());
    }

    private Date extractExpiration(String token) {
        return extractClaim(token, Claims::getExpiration);
    }

    private Key getSignInKey() {
        byte[] keyBytes = Decoders.BASE64.decode(SECRET_KEY);
        return Keys.hmacShaKeyFor(keyBytes);
    }
}
```

## 🧪 Probar la Solución

### 1. Reiniciar el Backend

```bash
./mvnw spring-boot:run
```

### 2. Probar con Postman

```bash
# 1. Login
POST http://localhost:8080/api/auth/login
Content-Type: application/json

{
  "email": "juan@example.com",
  "password": "password123"
}

# 2. Copiar el token de la respuesta

# 3. Agregar al carrito
POST http://localhost:8080/api/carrito/agregar
Authorization: Bearer {TOKEN}
Content-Type: application/json

{
  "pizzaId": 1,
  "cantidad": 2
}

# Debe retornar 200 OK, no 403
```

### 3. Verificar Logs del Backend

Deberías ver:
```
=== JWT Filter Debug ===
Path: /api/carrito/agregar
Auth Header: Bearer eyJhbGciOi...
JWT Token: eyJhbGciOiJIUzI1NiJ...
User Email: juan@example.com
Authentication set successfully for: juan@example.com
========================
```

## 📱 Frontend (Ya está corregido)

He mejorado el manejo de errores en el frontend:

### Cambios Realizados:

1. **CartProvider.addItem** ahora retorna `bool`:
   - `true` si se agregó correctamente
   - `false` si hubo error

2. **Mensajes de error amigables**:
   - 403 → "Error de autenticación. Por favor, vuelve a iniciar sesión."
   - 500 → "Error del servidor. Intenta nuevamente más tarde."
   - 404 → "Pizza no encontrada."

3. **SnackBars con colores**:
   - Verde para éxito
   - Rojo para error

4. **No más crashes**: La app maneja gracefully todos los errores

## 🎯 Checklist de Verificación Backend

- [ ] JwtAuthenticationFilter implementado
- [ ] Filtro registrado en SecurityConfig con `addFilterBefore`
- [ ] JwtService extrae correctamente el username
- [ ] UserDetailsService carga el usuario
- [ ] `SecurityContextHolder.getContext().setAuthentication()` se llama
- [ ] Logs muestran "Authentication set successfully"
- [ ] Postman retorna 200 OK (no 403)

## 🚨 Si el Problema Persiste

### Verificar application.properties

```properties
# JWT Secret (debe ser el mismo que se usó para generar el token)
jwt.secret=tu_secret_key_aqui_debe_ser_muy_largo_y_seguro

# JWT Expiration (24 horas)
jwt.expiration=86400000
```

### Verificar que el token no haya expirado

El token JWT tiene una fecha de expiración. Si el token expiró:
1. Hacer logout en el frontend
2. Hacer login nuevamente
3. Intentar agregar al carrito

### Verificar CORS

Si hay problemas de CORS, agregar en SecurityConfig:

```java
@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOrigins(Arrays.asList("*"));
    configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    configuration.setAllowedHeaders(Arrays.asList("*"));
    configuration.setAllowCredentials(true);
    
    UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
    source.registerCorsConfiguration("/**", configuration);
    return source;
}
```

## 📞 Resumen

### Problema:
- Backend retorna 403 en peticiones autenticadas
- JwtAuthenticationFilter no está procesando el token

### Solución:
1. Implementar correctamente JwtAuthenticationFilter
2. Registrar el filtro en SecurityConfig
3. Establecer la autenticación en SecurityContextHolder
4. Reiniciar el backend

### Frontend:
- ✅ Ya está corregido
- ✅ Maneja errores gracefully
- ✅ Muestra mensajes amigables
- ✅ No se crashea

---

**El problema es 100% del backend y debe ser resuelto allí. El frontend está funcionando correctamente.**
