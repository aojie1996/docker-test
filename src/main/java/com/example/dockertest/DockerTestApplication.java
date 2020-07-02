package com.example.dockertest;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;

@SpringBootApplication
@Controller
public class DockerTestApplication {

    public static void main(String[] args) {
        SpringApplication.run(DockerTestApplication.class, args);
    }

}
