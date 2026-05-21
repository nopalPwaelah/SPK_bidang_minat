"""
Converter untuk mengubah nilai (string, int, float) ke float dengan handling khusus
"""


def convert_nilai(value) -> float:
    """
    Konversi nilai ke float dengan proper error handling
    
    Args:
        value: str, int, float, atau None
    
    Returns:
        float: nilai yang sudah dikonversi
    
    Raises:
        ValueError: jika tidak bisa dikonversi
    """
    
    if value is None:
        raise ValueError("Nilai tidak boleh kosong")
    
    # Jika sudah float
    if isinstance(value, float):
        if value < 0 or value > 4.0:
            raise ValueError(f"Nilai harus antara 0-4.0, dapat {value}")
        return value
    
    # Jika integer
    if isinstance(value, int):
        float_val = float(value)
        if float_val < 0 or float_val > 4.0:
            raise ValueError(f"Nilai harus antara 0-4.0, dapat {float_val}")
        return float_val
    
    # Jika string
    if isinstance(value, str):
        # Trim whitespace
        value = value.strip()
        
        # Cek apakah kosong
        if not value or value.lower() in ['', 'null', 'none', '-']:
            raise ValueError("Nilai tidak boleh kosong")
        
        # Coba konversi
        try:
            float_val = float(value)
            
            # Validasi range
            if float_val < 0 or float_val > 4.0:
                raise ValueError(f"Nilai harus antara 0-4.0, dapat {float_val}")
            
            return float_val
        
        except ValueError as e:
            raise ValueError(f"Tidak bisa mengkonversi '{value}' ke angka: {e}")
    
    raise ValueError(f"Tipe data tidak didukung: {type(value)}")


def validate_nilai_dict(data: dict) -> bool:
    """
    Validasi dictionary nilai apakah semua value bisa dikonversi
    
    Args:
        data: dictionary dengan key=nama nilai, value=nilai
    
    Returns:
        bool: True jika semua valid
    
    Raises:
        ValueError: jika ada yang invalid
    """
    
    for key, value in data.items():
        try:
            convert_nilai(value)
        except ValueError as e:
            raise ValueError(f"Error di field '{key}': {e}")
    
    return True


def convert_nilai_dict(data: dict) -> dict:
    """
    Konversi semua nilai dalam dictionary ke float
    
    Args:
        data: dictionary dengan nilai yang perlu dikonversi
    
    Returns:
        dict: dictionary dengan nilai yang sudah dikonversi ke float
    
    Raises:
        ValueError: jika ada error konversi
    """
    
    result = {}
    
    for key, value in data.items():
        try:
            result[key] = convert_nilai(value)
        except ValueError as e:
            raise ValueError(f"Error di field '{key}': {e}")
    
    return result


# Mapping rating letter to numeric
LETTER_TO_NUMERIC = {
    'A': 4.0,
    'B': 3.0,
    'C': 2.0,
    'D': 1.0,
    'E': 0.0,
    'A+': 4.0,
    'B+': 3.5,
    'C+': 2.5,
    'D+': 1.5,
}


def convert_letter_grade(grade: str) -> float:
    """
    Konversi grade huruf ke nilai numerik
    
    Args:
        grade: string grade (A, B, C, dll)
    
    Returns:
        float: nilai numerik
    
    Raises:
        ValueError: jika grade tidak dikenal
    """
    
    if not isinstance(grade, str):
        raise ValueError("Grade harus berupa string")
    
    grade = grade.strip().upper()
    
    if grade not in LETTER_TO_NUMERIC:
        raise ValueError(f"Grade '{grade}' tidak dikenal. Gunakan: {list(LETTER_TO_NUMERIC.keys())}")
    
    return LETTER_TO_NUMERIC[grade]
