import json
import os
import base64
import urllib.request
import urllib.error

RESEND_API_KEY = os.environ.get("RESEND_API_KEY", "")
FROM_EMAIL     = os.environ.get("FROM_EMAIL", "onboarding@resend.dev")


def lambda_handler(event, context):
    # CORS preflight
    method = event.get("requestContext", {}).get("http", {}).get("method", "")
    if method == "OPTIONS":
        return cors_response(200, {"message": "ok"})

    try:
        body = event.get("body", "{}")
        if event.get("isBase64Encoded"):
            body = base64.b64decode(body).decode("utf-8")
        data = json.loads(body)

        name      = data.get("name", "Futuro Builder").strip()
        to_email  = data.get("email", "").strip()
        photo_b64 = data.get("photo", "")

        if not to_email:
            return cors_response(400, {"error": "Email requerido"})
        if not photo_b64:
            return cors_response(400, {"error": "Foto requerida"})

        # Quitar prefijo data:image/png;base64, si viene
        if "," in photo_b64:
            photo_b64 = photo_b64.split(",", 1)[1]

        send_email(name, to_email, photo_b64)
        return cors_response(200, {"message": "Correo enviado"})

    except Exception as e:
        print(f"ERROR: {e}")
        return cors_response(500, {"error": str(e)})


def send_email(name, to_email, photo_b64):
    subject = "¡Tu foto del AWS Student Builder Group!"

    html_body = f"""<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"/>
<style>
  body{{font-family:'Segoe UI',Arial,sans-serif;background:#1a1a2e;color:#fff;margin:0;padding:0}}
  .wrap{{max-width:560px;margin:0 auto;background:#1a1a2e;border-radius:16px;overflow:hidden}}
  .top{{background:#bf40bf;padding:28px 32px;text-align:center}}
  .top h1{{margin:0;font-size:1.2rem;color:#fff;letter-spacing:.04em}}
  .top p{{margin:4px 0 0;font-size:.78rem;color:rgba(255,255,255,.75)}}
  .body{{padding:32px}}
  .body h2{{color:#bf40bf;font-size:1.3rem;margin-top:0}}
  .body p{{line-height:1.7;color:rgba(255,255,255,.85)}}
  .photo{{text-align:center;margin:24px 0}}
  .photo img{{border-radius:12px;border:3px solid #bf40bf;max-width:100%;box-shadow:0 8px 32px rgba(191,64,191,.4)}}
  .cta{{display:inline-block;margin-top:16px;padding:12px 28px;background:#bf40bf;color:#fff;border-radius:8px;text-decoration:none;font-weight:700}}
  .foot{{padding:18px 32px;text-align:center;font-size:.7rem;color:rgba(255,255,255,.3);border-top:1px solid rgba(191,64,191,.2)}}
</style>
</head>
<body>
<div class="wrap">
  <div class="top">
    <h1>AWS Student Builder Group</h1>
    <p>at Instituto Tecnológico de Ocotlán</p>
  </div>
  <div class="body">
    <h2>Hola {name}, Futuro Builder Member 💜</h2>
    <p>Esta es tu foto del evento. <strong>¡Saliste muy Guap@!</strong> 📸</p>
    <p>Esperamos que te unas a nuestra comunidad y juntos sigamos dando el siguiente paso:<br/>
    <em>De aprender… a construir.</em> AWS Student Builder Groups 💜</p>
    <div class="photo">
      <img src="cid:photo.png" alt="Tu foto del evento"/>
    </div>
    <center><a class="cta" href="https://builder.aws.com/">Conoce AWS Builder Center →</a></center>
  </div>
  <div class="foot">
    AWS Student Builder Group · Instituto Tecnológico de Ocotlán<br/>
    Generado desde el Photo Booth del evento 📷
  </div>
</div>
</body>
</html>"""

    payload = {
        "from":    f"AWS Student Builder Group <{FROM_EMAIL}>",
        "to":      [to_email],
        "subject": subject,
        "html":    html_body,
        "attachments": [
            {"filename": "mi-foto-sbg.png", "content": photo_b64}
        ],
    }

    data_bytes = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        "https://api.resend.com/emails",
        data=data_bytes,
        headers={
            "Authorization": f"Bearer {RESEND_API_KEY}",
            "Content-Type":  "application/json",
        },
        method="POST",
    )

    try:
        with urllib.request.urlopen(req) as resp:
            result = json.loads(resp.read().decode("utf-8"))
            print(f"Resend OK: {result}")
    except urllib.error.HTTPError as e:
        err = e.read().decode("utf-8")
        print(f"Resend error {e.code}: {err}")
        raise Exception(f"Resend error {e.code}: {err}")


def cors_response(status_code, body_dict):
    return {
        "statusCode": status_code,
        "headers": {
            "Content-Type": "application/json",
        },
        "body": json.dumps(body_dict),
    }
