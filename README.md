# 📸 AWS Student Builder Group – Photo Booth

> Photo booth interactivo para eventos del AWS Student Builder Group at Instituto Tecnológico de Ocotlán. Toma una foto, agrega stickers de la identidad visual del SBG y recibe tu foto por correo.

![AWS Student Builder Group](https://i.ibb.co/N6b29RVr/AWS-Student-Builder-Group-RGB-Program-Icon-Magenta.png)

---

## 🚀 Demo

**Live:** [https://staging.d2pm9uwh5z4g6s.amplifyapp.com](https://staging.d2pm9uwh5z4g6s.amplifyapp.com)

---

## ✨ Features

- 📷 **Cámara en vivo** — abre la cámara del teléfono o PC
- 🎨 **Stickers arrastrables** — más de 60 iconos de la identidad visual del SBG en todos los colores
- 🖼 **Marco AWS Student Builder Group** — marco con logo SBG y AWS activable con toggle
- ⬇️ **Descargar foto** — guarda la foto con todos los stickers y el watermark de AWS
- 📧 **Enviar por correo** — popup que pide nombre y correo, envía la foto automáticamente
- 💜 **Identidad visual AWS SBG** — colores `#1a1a2e` + magenta `#bf40bf`, grid pattern, tipografía limpia

---

## 🛠 Stack

| Capa | Tecnología |
|------|-----------|
| Frontend | HTML + CSS + JavaScript vanilla |
| Hosting | AWS Amplify |
| Email | EmailJS (sin backend) |
| Imágenes | ImgBB CDN |
| Cámara | Web API `getUserMedia` |
| Canvas | HTML5 Canvas API |

---

## 📁 Estructura

```
Kiosko/
├── index.html          # App completa (todo en un archivo)
├── ito-black.png       # Logo ITO negro
├── ito-magenta.png     # Logo ITO magenta
├── lambda/             # Lambda AWS (opcional, no requerida con EmailJS)
│   ├── lambda_function.py
│   ├── deploy.bat
│   ├── deploy.ps1
│   └── cors.json
└── README.md
```

> Las imágenes de iconos SBG y logos AWS están hosteadas en ImgBB — no se necesitan localmente.

---

## ⚙️ Configuración

### EmailJS
El proyecto usa [EmailJS](https://emailjs.com) para enviar correos directo desde el browser.

Variables configuradas en `index.html`:
```js
emailjs.init("TU_PUBLIC_KEY");
// ...
emailjs.send('TU_SERVICE_ID', 'TU_TEMPLATE_ID', { ... })
```

Para configurar tu propia cuenta:
1. Crea cuenta en [emailjs.com](https://emailjs.com)
2. Conecta tu servicio de correo (Gmail, Outlook, etc.)
3. Crea un template con las variables:
   - `{{to_name}}` — nombre del destinatario
   - `{{to_email}}` — correo del destinatario
   - `{{message}}` — mensaje del correo
   - `{{photo_url}}` — foto en base64 (agregar como `<img src="{{photo_url}}"/>` en el HTML del template)
4. Reemplaza en `index.html`:
   - `5Axz1Ne_iY6Kie-94` → tu Public Key
   - `service_hg64jir` → tu Service ID
   - `template_3h0mf5w` → tu Template ID

---

## 🚀 Deploy en AWS Amplify

1. Crea un ZIP con solo el `index.html`:
```powershell
Compress-Archive -Path ".\index.html" -DestinationPath "kiosko.zip" -Force
```

2. Ve a [AWS Amplify Console](https://console.aws.amazon.com/amplify)
3. **Create new app** → **Deploy without Git** → **Drag and drop**
4. Sube el ZIP y despliega

---

## 🎨 Identidad Visual

Basada en la identidad del **AWS Student Builder Group**:

| Color | Hex |
|-------|-----|
| Fondo principal | `#1a1a2e` |
| Fondo secundario | `#16213e` |
| Magenta accent | `#bf40bf` |
| Purple | `#7b2fff` |
| White | `#ffffff` |

---

## 📦 Iconos incluidos

Todos los iconos oficiales del AWS Student Builder Group en 7 colores cada uno:

- 👥 **Equipo** (Teams)
- 🪜 **Escalera** (Ladder)  
- 💧 **Gota** (Drop)
- ⚡ **Rayo** (Bolt)
- 🕐 **Reloj** (Clock)
- 🔑 **Llave** (Key)
- 🔧 **Llave Alt** (Wrench)
- 🏆 **Trofeo** (Trophy)
- 🎤 **Speaker**
- 😊 **Smile Corchete** (Single Bracket Smile)
- 😄 **Smile Doble** (Double Bracket Smile)
- 🖼 **Program Icons** SBG (7 colores)
- ☁️ **Logos AWS** (White, Black, REV, Smile)
- 🏫 **Logos ITO** (Black, Magenta)

---

## 👨‍💻 Desarrollado con

**Kiro** — AI-powered development environment  
**AWS Student Builder Group at ITO Ocotlán** — CardenalITOs 💜

---

## 📄 Licencia

COPYRIGHT NOTICE & INTELLECTUAL PROPERTY DISCLAIMER
AWS Student Builder Group Photo Booth
Instituto Tecnológico de Ocotlán — CardenalITOs

Copyright © 2026 AWS Student Builder Group at Instituto Tecnológico de Ocotlán.
All rights reserved.

AVISO LEGAL SOBRE PROPIEDAD INTELECTUAL Y MARCAS REGISTRADAS

Todos los logotipos, íconos, imágenes, nombres comerciales, marcas y activos
gráficos incluidos en este proyecto que correspondan a "Amazon Web Services",
"AWS", "AWS Community", "AWS Student Builder Groups" y sus variantes son
propiedad exclusiva de Amazon Web Services, Inc. y/o sus afiliados.
Su uso en este proyecto se realiza bajo el marco del programa oficial
AWS Student Builder Groups y está sujeto a las Directrices de Uso de Marcas
Registradas de Amazon Web Services disponibles en:
https://aws.amazon.com/trademark-guidelines/

RESTRICCIONES DE USO

Queda estrictamente prohibido, sin autorización previa y por escrito de
Amazon Web Services, Inc. y/o del AWS Student Builder Group at ITO Ocotlán:

  1. Reproducir, copiar, distribuir o sublicenciar total o parcialmente
     los activos visuales, logotipos e íconos contenidos en este proyecto
     con fines distintos a los eventos oficiales del programa AWS Student
     Builder Groups.

  2. Utilizar las marcas, logotipos o identidad visual de AWS, AWS Community
     o AWS Student Builder Groups para representar, promocionar o identificar
     productos, servicios u organizaciones no autorizadas por Amazon Web
     Services, Inc.

  3. Modificar, alterar, distorsionar o crear obras derivadas de los activos
     gráficos protegidos sin la autorización expresa del titular de los
     derechos de propiedad intelectual correspondiente.

  4. Hacer uso de los elementos visuales de este proyecto de manera que
     pueda inducir a confusión, engaño o asociación indebida con Amazon
     Web Services, Inc. o cualquiera de sus programas oficiales.

CÓDIGO FUENTE

El código fuente de esta aplicación (HTML, CSS, JavaScript) es de autoría
del AWS Student Builder Group at Instituto Tecnológico de Ocotlán y se
distribuye bajo los términos de uso interno del programa. Cualquier
reutilización del código deberá remover todos los activos visuales
protegidos por derechos de autor antes de su redistribución.

EXENCIÓN DE RESPONSABILIDAD

Este proyecto es una herramienta desarrollada de forma independiente por
miembros del programa AWS Student Builder Groups con fines educativos y
comunitarios. No constituye un producto oficial de Amazon Web Services, Inc.
Amazon Web Services no patrocina, avala ni es responsable del contenido,
funcionamiento o disponibilidad de esta aplicación.

Para consultas sobre licenciamiento y uso de marcas:
  AWS Trademark: https://aws.amazon.com/trademark-guidelines/
  Contacto SBG ITO: cardenalitos@itocotlan.com

"AWS", "Amazon Web Services" y los logotipos relacionados son marcas
registradas de Amazon.com, Inc. o sus filiales en los Estados Unidos
y/o en otros países.

