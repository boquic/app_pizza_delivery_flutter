# 🔧 Configuración del Backend para Flutter

## Problema Actual

El backend está devolviendo **403 Forbidden** en los endpoints de autenticación (`/api/auth/login`), lo que impide que la app Flutter pueda iniciar sesión.

## Soluciones Necesarias

### 1. Configurar CORS

El backend debe permitir peticiones desde cualquier origen durante desarrollo. Crea o actualiza la clase de configuración CORS:

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

@Configuration
public class CorsConfig {
    
    @Bean
    public CorsFilter corsFilter() {
        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        CorsConfiguration config = new CorsConfiguration();
        
        // Permitir credenciales
        config.setAllowCredentials(true);
        
        // Permitir todos los orígenes en desarrollo
        config.addAllowedOriginPattern("*");
        
        // Permitir todos los headers
        config.addAllowedHeader("*");
        
        // Permitir todos los métodos HTTP
        config.addAllowedMethod("*");
        
        source.registerCorsConfiguration("/**", config);
        return new CorsFilter(source);
    }
}
```

### 2. Configurar Spring Security

Asegúrate de que los endpoints de autenticación sean públicos. En tu clase `SecurityConfig`:

```java
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {
        http
            .cors().and()
            .csrf().disable()
            .sessionManagement()
                .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
            .and()
            .authorizeHttpRequests(auth -> auth
                // Endpoints públicos
                .requestMatchers("/api/auth/**").permitAll()
                .requestMatchers("/api/pizzas/**").permitAll()
                .requestMatchers("/ws/**").permitAll()
                .requestMatchers("/error").permitAll()
                
                // Endpoints de usuario (requieren autenticación)
                .requestMatchers("/api/usuario/**").authenticated()
                
                // Endpoints de admin (requieren rol ADMIN)
                .requestMatchers("/api/admin/**").hasRole("ADMIN")
                
                // Cualquier otra petición requiere autenticación
                .anyRequest().authenticated()
            );
        
        return http.build();
    }
}
```

### 3. Verificar el Controlador de Autenticación

Asegúrate de que tu `AuthController` tenga las anotaciones correctas:

```java
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*") // Adicional para desarrollo
public class AuthController {
    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody LoginRequest request) {
        // Tu lógica de login
    }
    
    @PostMapping("/register")
    public ResponseEntity<?> register(@RequestBody RegisterRequest request) {
        // Tu lógica de registro
    }
}
```

### 4. Verificar application.properties

Agrega estas propiedades si no las tienes:

```properties
# CORS
spring.web.cors.allowed-origins=*
spring.web.cors.allowed-methods=GET,POST,PUT,DELETE,OPTIONS
spring.web.cors.allowed-headers=*
spring.web.cors.allow-credentials=true

# Security
spring.security.filter.order=5
```

## Prueba Rápida

Después de hacer los cambios, prueba el endpoint desde PowerShell:

```powershell
$body = @{
    email='admin@pizzasreyna.com'
    password='admin123'
} | ConvertTo-Json

Invoke-RestMethod -Uri 'http://localhost:8080/api/auth/login' -Method Post -Body $body -ContentType 'application/json'
```

Deberías recibir una respuesta con el token y los datos del usuario.

## Endpoints que DEBEN ser públicos

- `POST /api/auth/login`
- `POST /api/auth/register`
- `GET /api/pizzas` (opcional, pero recomendado para ver el catálogo sin login)
- `GET /api/pizzas/{id}` (opcional)

## Endpoints que DEBEN requerir autenticación

- `GET /api/usuario/carrito`
- `POST /api/usuario/carrito/agregar`
- `POST /api/usuario/pedidos`
- `GET /api/usuario/pedidos`

## Endpoints que DEBEN requerir rol ADMIN

- `POST /api/admin/pizzas`
- `PUT /api/admin/pizzas/{id}`
- `DELETE /api/admin/pizzas/{id}`
- `GET /api/admin/pedidos`
- `PUT /api/admin/pedidos/{id}/estado`

## Verificación

Una vez configurado el backend, reinícialo y verifica:

1. ✅ El login funciona desde PowerShell
2. ✅ La app Flutter puede hacer login
3. ✅ El token se guarda correctamente
4. ✅ Las peticiones autenticadas incluyen el header `Authorization: Bearer {token}`

## Notas Importantes

- En **producción**, reemplaza `allowed-origins=*` con los dominios específicos de tu app
- Considera usar variables de entorno para configurar CORS según el ambiente
- El token JWT debe incluirse en el header `Authorization` con el formato `Bearer {token}`
