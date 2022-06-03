package middlewares

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
)

type CustomClaims struct {
	Sub string `json:"sub"`
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

		token, _ := jwt.ParseWithClaims(accessToken, &CustomClaims{}, func(token *jwt.Token) (interface{}, error) {
			// since we only use the one private key to sign the tokens,
			// we also only use its public counter part to verify
			return "LOL", nil
		})

		fmt.Println(token, token.Claims)

		// if err != nil {
		// 	c.JSON(401, gin.H{
		// 		"error":   true,
		// 		"message": "Unauthorized",
		// 	})
		// 	c.Abort()
		// 	return
		// }

		claims := token.Claims.(*CustomClaims)
		// fmt.Println(claims.UserId)
		c.Set("user_id", claims.Sub)

		c.Next()
	}
}
