# Usa una imagen base oficial de Python
FROM python:3.11-slim

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /app

# Instala dependencias del sistema (¡Clave para WeasyPrint!)
# Primero, herramientas básicas de construcción
RUN apt-get update && apt-get install -y \
    build-essential \
    pkg-config \
    --no-install-recommends

# Copia tu archivo packages.txt y usa apt-get para instalar todo lo que está listado
COPY packages.txt .
RUN apt-get update && apt-get install -y --no-install-recommends $(cat packages.txt)

# Copia e instala las dependencias de Python
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copia el resto del código de tu aplicación
COPY . .

# Expone el puerto que Cloud Run usará.
EXPOSE 8080

# Comando para iniciar la aplicación (basado en tu manage.py)
# Cloud Run inyecta la variable $PORT (usualmente 8080)
CMD ["gunicorn", "manage:app", "--bind", "0.0.0.0:$PORT", "--workers", "2"]