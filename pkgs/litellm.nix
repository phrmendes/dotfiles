{ litellm }:
litellm.overridePythonAttrs (old: {
  postPatch = (old.postPatch or "") + ''
    for f in \
      litellm/llms/vertex_ai/vertex_ai_partner_models/main.py \
      litellm/llms/vertex_ai/vertex_ai_non_gemini.py \
      litellm/llms/vertex_ai/vertex_gemma_models/main.py \
      litellm/llms/vertex_ai/vertex_model_garden/main.py; do
      [ -f "$f" ] || continue
      substituteInPlace "$f" \
        --replace-quiet \
          "import vertexai" \
          "vertexai = type('vertexai', (), {'preview': type('preview', (), {'language_models': None})()})()" \
        --replace-quiet \
          "if not (hasattr(vertexai, \"preview\") or hasattr(vertexai.preview, \"language_models\")):" \
          "if False:"
    done
  '';
})
