package nz.net.osnz.controller

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.RestController

/**
 * @author Kefeng Deng (deng@51any.com)
 */
@RestController
class HealthController {


    @GetMapping('/_ah/health')
    ResponseEntity healthHandler() {
        println("Health check")
        return ResponseEntity.ok().build()
    }

    @GetMapping('/readiness_check')
    ResponseEntity readinessCheck() {
        println('readiness check')
        return ResponseEntity.ok().build()
    }
}
