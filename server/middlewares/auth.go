package middlewares

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/overlorddamygod/qft-server/configs"
)

type CustomClaims struct {
	UserId string `json:"user_id"`
	jwt.StandardClaims
}

func IsLoggedIn() gin.HandlerFunc {
	return func(c *gin.Context) {
		var accessToken string = c.GetHeader("Authorization")

		if accessToken == "" {
			c.JSON(401, gin.H{
				"error":   true,
				"message": "Unauthorized",
			})

			c.Abort()
			return
		}
		token, err := jwt.ParseWithClaims(accessToken, &CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
			if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
				return nil, fmt.Errorf("unexpected signing method: %v", token.Header["alg"])
			}
			return configs.MainConfig.JwtAccessSecret, nil
		})

		if err != nil {
			fmt.Println(err)
			c.JSON(401, gin.H{
				"error":   true,
				"message": "Unauthorized",
			})
			c.Abort()
			return
		}

		claims := token.Claims.(*CustomClaims)

		c.Set("user_id", claims.UserId)

		c.Next()
	}
}
