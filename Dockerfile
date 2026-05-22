# Hafif bir Python sürümü kullanıyoruz
FROM python:3.10-slim

# Çalışma klasörümüzü belirliyoruz
WORKDIR /app

# Gereksinimleri kopyala ve kur
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# SİHİRLİ DOKUNUŞ 1: İnternet engelini aşmak için modeli robot hazırlarken indirip imaja gömüyoruz!
ENV HF_HOME=/app/huggingface_cache
ENV TRANSFORMERS_CACHE=/app/huggingface_cache
RUN python -c "from transformers import AutoTokenizer, AutoModel; AutoTokenizer.from_pretrained('dbmdz/bert-base-turkish-cased'); AutoModel.from_pretrained('dbmdz/bert-base-turkish-cased')"

# Kodları kopyala
COPY . .

# SİHİRLİ DOKUNUŞ 2: Klasör izinlerini herkese aç (SAP yetki duvarını aşmak için)
RUN chmod -R 777 /app

# İnternete açılacak kapı
EXPOSE 9000

# Sunucuyu başlat (Timeout süresini 120'den 300 saniyeye çıkardık, fişi erken çekmesin)
CMD ["gunicorn", "app:app", "--timeout", "300", "-b", "0.0.0.0:9000"]
