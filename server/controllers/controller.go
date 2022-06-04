package controllers

import (
	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/overlorddamygod/qft-server/configs"
	"gorm.io/gorm"
)

type BaseController struct {
	config *configs.Config
	db     *gorm.DB
}

func NewBaseController(config *configs.Config, db *gorm.DB) *BaseController {
	return &BaseController{
		config: config,
		db:     db,
	}
}

func (BaseController) GetUserUUid(c *gin.Context) (uuid.UUID, error) {
	user_id, _ := c.Get("user_id")

	return uuid.Parse(user_id.(string))
}

func (b BaseController) GetDb() *gorm.DB {
	return b.db
}
