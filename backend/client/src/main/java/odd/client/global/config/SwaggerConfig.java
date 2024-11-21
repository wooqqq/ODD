package odd.client.global.config;

import io.swagger.v3.oas.models.servers.Server;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springdoc.core.models.GroupedOpenApi;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        String jwtSchemeName = "JWT";
        SecurityRequirement securityRequirement = new SecurityRequirement().addList(jwtSchemeName);

        Components components = new Components()
                .addSecuritySchemes(jwtSchemeName, new SecurityScheme()
                        .name(jwtSchemeName)
                        .type(SecurityScheme.Type.HTTP)
                        .scheme("bearer")
                        .bearerFormat("JWT"));

        ArrayList<Server> servers = new ArrayList<>();
        servers.add(new Server().url("https://oodongdan.com/client").description("Deploy Server"));
        servers.add(new Server().url("http://localhost:8080/client").description("Local Server"));

        return new OpenAPI()
                .info(apiInfo())
                .servers(servers)
                .addSecurityItem(securityRequirement)
                .components(components);
    }

    private Info apiInfo(){
        return new Info().title("Client API Documentation")
                .description("API documentation for client endpoints, including authentication and point operations")
                .version("1.0.0");
    }

}