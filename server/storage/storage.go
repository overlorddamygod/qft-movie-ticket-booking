package storage

import (
	"github.com/overlorddamygod/qft-server/configs"
	storage_go "github.com/overlorddamygod/storage-go"
)

func NewStorage(configs *configs.Config) *storage_go.Client {
	return storage_go.NewClient(configs.Storage.Endpoint, configs.Storage.SecretKey, nil)
}
