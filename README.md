# Perbaikan Sistem Damage pada Player

## Fitur yang Ditambahkan

### 1. Invulnerability Window

Menambahkan periode invulnerability setelah player menerima damage, sehingga player tidak akan menerima damage berulang dalam waktu singkat.

```gdscript
@export var invulnerabilityDuration: float = 1.5
var lastDamageTime: int = 0

func _on_hurt_box_area_entered(area: Area2D) -> void:
    if area.name == "hitBox":
        var currentTime = Time.get_ticks_msec()
        var timeSinceLastDamage = currentTime - lastDamageTime
        
        if timeSinceLastDamage < invulnerabilityDuration * 1000:
            return
            
        lastDamageTime = currentTime
        // proses damage
```

#### Detail Implementasi:
- Menambahkan variabel `lastDamageTime` untuk melacak waktu terakhir player menerima damage
- Menggunakan `Time.get_ticks_msec()` untuk mendapatkan waktu saat ini dalam milidetik
- Mengecek apakah sudah cukup waktu berlalu sejak damage terakhir
- Jika belum cukup waktu (masih dalam invulnerability window), damage diabaikan

### 2. Perbaikan Sistem Knockback

Memperbaiki sistem knockback agar player selalu terdorong menjauh dari enemy dan tidak tertarik ke arah enemy.

```gdscript
func knockBack(enemyPosition: Vector2):
    var knockBackDir = (global_position - enemyPosition).normalized()
    
    if knockBackDir.length() < 0.1:
        knockBackDir = Vector2(0, 1)
    
    velocity = knockBackDir * knockBackPower
    
    move_and_slide()
    move_and_slide()
```

#### Detail Implementasi:
- Mengubah parameter fungsi knockBack dari `enemyVelocity` menjadi `enemyPosition`
- Menghitung arah knockback berdasarkan posisi relatif player dan enemy `(global_position - enemyPosition)`
- Memastikan player selalu terdorong **menjauh** dari enemy, bukan berdasarkan arah gerak enemy
- Menambahkan pengecekan untuk kondisi edge case ketika posisi terlalu dekat
- Menggunakan `move_and_slide()` dua kali untuk memastikan player terdorong cukup jauh

### 3. Efek Visual Blink

Menambahkan efek visual blink ketika player terkena damage.

```gdscript
func startInvulnerabilityEffect():
    hurtTimer.start()
    await hurtTimer.timeout
    hurtEffects.play("RESET")
```

## Manfaat Perubahan

1. **Mencegah Damage Beruntun** - Player tidak akan langsung menerima damage lagi setelah terkena serangan, memberikan waktu untuk bereaksi
2. **Gameplay yang Lebih Adil** - Knockback yang konsisten dan selalu mengarah ke lokasi yang aman
3. **Visual Feedback** - Player dapat melihat dengan jelas kapan mereka sedang dalam invulnerability state

## Cara Kerja

Ketika player bertabrakan dengan enemy:

1. Sistem mengecek apakah player masih dalam invulnerability window
2. Jika ya, damage diabaikan
3. Jika tidak, player menerima damage dan knockback
4. Player didorong ke arah yang menjauh dari enemy
5. Invulnerability window dimulai, ditandai dengan efek blink
6. Selama durasi invulnerability, player kebal terhadap damage
