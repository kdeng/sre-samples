package nz.net.osnz.controller

import org.springframework.http.ResponseEntity
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RestController

/**
 * @author Kefeng Deng (deng@51any.com)
 */
@RestController
class TaskController {

    @GetMapping('/work/hello/{name}')
    String hello(@PathVariable('name') String name) {
        println("Hello to ${name}")
        return "Hello ${name}"
    }

    @GetMapping('/task/hello/{name}')
    ResponseEntity submitTaskJob(@PathVariable('name') String name) {
        String queueName = System.getProperty('QUEUE_NAME', 'kefeng-queue')
//        Queue queue = QueueFactory.getQueue(queueName)
//        queue.add(TaskOptions.Builder.withUrl("/work/hello/${name}").param("name", name))
        println("Created a task")
        return ResponseEntity.accepted().build()

        Pubsub
    }

}
