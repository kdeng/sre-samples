package nz.net.osnz

import groovy.transform.CompileStatic
import org.springframework.boot.Banner
import org.springframework.boot.SpringApplication
import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

/**
 * @author Kefeng Deng (deng@51any.com)
 */
@SpringBootApplication
@RestController
@CompileStatic
class Application {

    static void main(String[] args) {
        SpringApplication app = new SpringApplication(Application)
        app.bannerMode = Banner.Mode.OFF
        app.run(args)
    }

    @GetMapping(path = '/')
    String index() {
        return 'Hello World'
    }

}
