# E-OS · PME

Я вирішив створити свій легкий дистрибутив. Взяв за основу Debian з KDE plasma.
Далі нарощували фічі: нижня панель по центру з круглою іконкою меню, акцентний колір, що сам підбирається з ваших шпалер, тиха фонова музика окремим повзунком у мікшері з автоприглушенням, коли грає щось інше, KDE Connect для телефону, Waydroid для APK (тільки amd64), і автоналаштування графіки — повні ефекти при RAM>4ГБ, легкий режим інакше.

**E-OS by PME** — лише `amd64`, Debian bookworm, KDE Plasma + SDDM.

## Збірка
- GitHub Actions: вкладка *Actions → build-iso → Run workflow*, ISO з'явиться в артефактах.
- Локально (Debian/Ubuntu, root): `bash ./build.sh` → `E-OS-amd64.iso`

## Вхід у live-сесію
Користувач `eos`, пароль `live` (стандарт live-config).

## Що де
- `assets/` — шпалери, логотипи, фонова музика
- `config-tree/` — пакети, хуки, файли системи (SDDM-тема, Plymouth-тема, скрипти `eos-*`)
- `.github/workflows/build-iso.yml` — збірка в Actions
