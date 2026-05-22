# Hafif bir Python sürümü kullanıyoruz
FROM python:3.10-slim

# Çalışma klasörümüzü belirliyoruz
WORKDIR /app

# Gereksinimleri kopyala ve kur
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Kodları kopyala
COPY . .

# SIHIRLI DOKUNUS: SAP AI Core yetki krizini asmak icin indirme klasorunu degistiriyoruz
ENV HF_HOME=/tmp/huggingface
ENV TRANSFORMERS_CACHE=/tmp/huggingface
RUN mkdir -p /tmp/huggingface && chmod -R 777 /tmp/huggingface

# İnternete açılacak kapı
EXPOSE 9000

# Sunucuyu başlat
CMD ["gunicorn", "app:app", "--timeout", "120", "-b", "0.0.0.0:9000"]
