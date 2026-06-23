package com.easycare.controller;

import com.easycare.dto.AuthRequestDto;
import com.easycare.dto.AuthResponseDto;
import com.easycare.dto.RegisterRequestDto;
import com.easycare.service.AuthService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*", maxAge = 3600)
public class AuthController {

    @Autowired
    private AuthService authService;

    @PostMapping("/register")
    public ResponseEntity<?> register(@Valid @RequestBody RegisterRequestDto registerRequestDto) {
        return new ResponseEntity<>(authService.register(registerRequestDto), HttpStatus.CREATED);
    }

    @PostMapping("/login")
    public ResponseEntity<?> login(@Valid @RequestBody AuthRequestDto authRequestDto) {
        AuthResponseDto authResponseDto = authService.login(authRequestDto);
        return ResponseEntity.ok(authResponseDto);
    }
}
