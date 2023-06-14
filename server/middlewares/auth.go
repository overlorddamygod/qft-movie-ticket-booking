package middlewares

import (
	"fmt"

	"github.com/gin-gonic/gin"
	"github.com/golang-jwt/jwt"
	"github.com/overlorddamygod/qft-server/configs"
	"gorm.io/gorm"
)

type Middleware struct {
	db *gorm.DB
}

func NewMiddlewares(db *gorm.DB) *Middleware {
	return &Middleware{
		db: db,
	}
}

type CustomClaims struct {
	UserId string `json:"user_id"`
	Roles  []int  `json:"roles"`
	jwt.StandardClaims
}

func (m Middleware) IsLoggedIn() gin.HandlerFunc {
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
			c.JSON(401, gin.H{
				"error":   true,
				"message": "Unauthorized",
			})
			c.Abort()
			return
		}

		claims := token.Claims.(*CustomClaims)

		c.Set("user_id", claims.UserId)
		c.Set("roles", claims.Roles)

		c.Next()
	}
}

func hasAdminRole(arr []int, item int) bool {
	for _, value := range arr {
		if value == item {
			return true
		}
	}
	return false
}

var ADMIN = 1

func (m Middleware) IsAdmin() gin.HandlerFunc {
	return func(c *gin.Context) {
		roles, exists := c.Get("roles")

		if !exists {
			c.JSON(401, gin.H{
				"error":   true,
				"message": "Unauthorized",
			})
			c.Abort()
			return
		}

		rolesInt := roles.([]int)

		if !hasAdminRole(rolesInt, ADMIN) {
			c.JSON(401, gin.H{
				"error":   true,
				"message": "Unauthorized",
			})
			c.Abort()
			return
		}

		c.Next()
	}
}
