package org.example;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Map;
import java.util.stream.Stream;

public class DotEnv {
    private final Map<String, String> envMap;

    public DotEnv() {
        envMap = new HashMap<>();
        try (Stream<String> stream = Files.lines(Paths.get(".env"))) {
            stream.forEach(line -> {
                String[] parts = line.split("=", 2);
                envMap.put(parts[0], parts[1]);
            });
        } catch (IOException e) {
            throw new RuntimeException(".env file does not exist");
        }
    }

    public String get(String key) {
        return envMap.get(key);
    }
}