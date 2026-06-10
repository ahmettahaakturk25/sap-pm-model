# 1. Python 3.10-slim ile devam ediyoruz
FROM python:3.10-slim

WORKDIR /app

# Önce requirements.txt'yi kopyalıyoruz
COPY requirements.txt .

# 2. NumPy sürümünü garantiye almak için kurulum sırasında 
# --no-cache-dir kullandığın için sorun çıkmaz ama requirements.txt'de
# "numpy<2.0" olduğundan emin olman yeterli.
RUN pip install --no-cache-dir -r requirements.txt

# Model indirme kısmın gayet başarılı, aynı şekilde kalabilir
ENV HF_HOME=/app/huggingface_cache
ENV TRANSFORMERS_CACHE=/app/huggingface_cache
RUN python -c "from transformers import AutoTokenizer, AutoModel; AutoTokenizer.from_pretrained('dbmdz/bert-base-turkish-cased'); AutoModel.from_pretrained('dbmdz/bert-base-turkish-cased')"

COPY . .

# 3. İzinler
RUN chmod -R 777 /app

EXPOSE 9000

# 4. Gunicorn başlangıcı (Burada ufak bir ekleme yapabiliriz)
CMD ["gunicorn", "app:app", "--timeout", "300", "--workers", "1", "--bind", "0.0.0.0:9000"]
