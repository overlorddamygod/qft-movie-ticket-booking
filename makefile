dev-client:
	cd client && npm run dev && cd ..
	
dev-server:
	cd server && go run main.go && cd ..

release-client:
	cd client && npm run build && npm run start && cd ..

release-server:
	cd client && go build -o main main.go && ./main && cd ..

docker-run:
	cd docker && docker compose up && cd ..

dev-up:
	cd docker && docker compose --file docker-compose.dev.yml up && cd ..

dev-down:
	cd docker && docker compose --file docker-compose.dev.yml down && cd ..