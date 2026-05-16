class AIService:
  @staticmethod
  async def classify_waste_image(_image_url: str) -> dict:
    return {
        "status": "not_configured",
        "label": "unknown",
        "confidence": 0,
        "message": "TensorFlow Lite hook placeholder",
    }
