from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    MONGODB_URI: str = "mongodb://localhost:27017"
    DB_NAME: str = "gigcredit"
    GROQ_API_KEY: str = ""
    HMAC_SECRET: str = "gigcredit-secure-hmac-secret"
    SERVER_API_KEY: str = "gigcredit-api-key"
    ENABLE_HMAC: bool = False
    SKIP_AUTH: bool = True

    model_config = SettingsConfigDict(env_file=".env")


settings = Settings()
