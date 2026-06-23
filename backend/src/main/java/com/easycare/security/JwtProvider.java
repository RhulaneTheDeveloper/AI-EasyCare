package com.easycare.security;

import io.jsonwebtoken.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Component;

import java.util.Date;

@Component
public class JwtProvider {

    @Value("${app.jwtSecret:easycare-secret-key-2024}")
    private String jwtSecret;

    @Value("${app.jwtExpirationInMs:86400000}")
    private int jwtExpirationInMs;

    public String generateToken(Authentication authentication) {
        String username = authentication.getName();
        Date now = new Date();
        Date expiryDate = new Date(now.getTime() + jwtExpirationInMs);

        return Jwts.builder()
                .setSubject(username)
                .setIssuedAt(now)
                .setExpiration(expiryDate)
                .signWith(SignatureAlgorithm.HS512, jwtSecret)
                .compact();
    }

    public String getUsernameFromToken(String token) {
        return Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token).getBody().getSubject();
    }

    public boolean validateToken(String token) {
        try {
            Jwts.parser().setSigningKey(jwtSecret).parseClaimsJws(token);
            return true;
        } catch (SecurityException e) {
            System.err.println("Invalid JWT signature: " + e);
        } catch (MalformedJwtException e) {
            System.err.println("Invalid JWT token: " + e);
        } catch (ExpiredJwtException e) {
            System.err.println("Expired JWT token: " + e);
        } catch (UnsupportedJwtException e) {
            System.err.println("Unsupported JWT token: " + e);
        } catch (IllegalArgumentException e) {
            System.err.println("JWT claims string is empty: " + e);
        }
        return false;
    }
}
