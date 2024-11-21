package odd.manager.global.config;

import io.swagger.v3.oas.models.servers.Server;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;

@Configuration
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        ArrayList<Server> servers = new ArrayList<>();
        servers.add(new Server().url("https://oodongdan.com/manager").description("Deploy Server"));
        servers.add(new Server().url("http://localhost:8081/manager").description("Local Server"));

        return new OpenAPI()
                .info(apiInfo())
                .servers(servers);
    }

    private Info apiInfo(){
        return new Info().title("Manager API Documentation")
                .description("API documentation for manager endpoints")
                .version("1.0.0");
    }
}
