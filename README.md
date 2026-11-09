# Forever Soulshot

## English

Forever Soulshot adds configurable weapon sound effects to **World of Warcraft: Forever** (interface 16001). It has separate switches for auto-attacks and offensive abilities. It supports dedicated effects for two-handed swords, maces, daggers, and bows, with a general effect for other offensive abilities.

### Install and configure

1. Copy the `ForeverSoulshot` folder to `_forever_/Interface/AddOns/`.
2. The GitHub repository contains the addon code. To use it, add audio files you have permission to use in `ForeverSoulshot/Sounds/`, named `greatsword.ogg`, `mace.ogg`, `dagger.ogg`, `bow.ogg`, and `soulshot.ogg` (general effect).
3. Restart WoW, then run `/soulshot` or open **Settings → AddOns → Forever Soulshot** to choose and preview sounds. The addon uses the game's sound effects (SFX) channel.

Sounds follow swings, shots, and successful casts, so they may also play when an attack misses. The combat log can stay closed. Offensive abilities whose spell IDs the client hides are skipped.

### Bugs and suggestions

Open an issue in English or Russian. For a **bug**, include the addon version, WoW Forever build and client language, your class and weapon or ability, steps to reproduce, and expected and actual results. Include the Lua error text if one appears. For a **feature request**, describe the behavior you want and give an example of when you would use it. [Open an issue](https://github.com/VillainRU/ForeverSoulshot/issues/new/choose)

## Русский

Forever Soulshot добавляет настраиваемые звуки оружия в **World of Warcraft: Forever** (интерфейс 16001). Автоатаки и атакующие умения можно включать отдельно. Поддерживаются разные звуки для двуручных мечей, булав, кинжалов и луков, а для прочих атакующих умений предусмотрен общий эффект.

### Установка и настройка

1. Скопируйте папку `ForeverSoulshot` в `_forever_/Interface/AddOns/`.
2. На GitHub размещён код аддона. Для работы положите разрешённые к использованию звуковые файлы в `ForeverSoulshot/Sounds/`. Названия файлов — `greatsword.ogg`, `mace.ogg`, `dagger.ogg`, `bow.ogg` и `soulshot.ogg` (общий эффект).
3. Перезапустите WoW и введите `/soulshot` или откройте **Настройки → Аддоны → Forever Soulshot**. Там можно выбрать и прослушать звуки. Громкость регулируется через игровые звуковые эффекты (SFX).

Звук привязан к взмаху, выстрелу или успешному применению умения, поэтому может прозвучать и при промахе. Журнал боя можно держать закрытым. Умения, ID которых клиент скрывает, пропускаются.

### Баг-репорты и пожелания

Откройте Issue на русском или английском. Для **баг-репорта** укажите версию аддона, сборку WoW Forever и язык клиента, класс и оружие или умение, шаги воспроизведения, ожидаемый и фактический результат. Если появилась Lua-ошибка, приложите её текст. Для **пожелания** опишите нужное поведение и приведите пример, когда оно пригодится. [Создать Issue](https://github.com/VillainRU/ForeverSoulshot/issues/new/choose)
