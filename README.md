# Custom Tetris com Flutter

![Logo do Custom Tetris](https://github.com/GuDevBot/games.custom-tetris/blob/main/assets/images/tetris.png)

Um projeto de jogo Tetris clássico, construído do zero com o framework Flutter. Este repositório documenta a jornada de desenvolvimento, desde a lógica principal do jogo até a implementação de funcionalidades como áudio e pontuação.

---

## ✨ Funcionalidades Principais

* **Gameplay Clássica:** Movimentação, rotação e encaixe de peças (Tetrominós).
* **Sistema de Pontuação:** Ganhe pontos ao aterrissar peças e bônus ao limpar múltiplas linhas de uma vez.
* **Áudio Imersivo:** Música de fundo contínua e efeitos sonoros para ações importantes, como limpar linhas e aterrissar peças.
* **Controles Intuitivos:** Interface com botões para movimentação, rotação e para acelerar a queda da peça ("soft drop").
* **Pause e Game Over:** Funcionalidade completa para pausar/retomar o jogo e uma tela de "Game Over" ao final.
* **Multiplataforma:** Desenvolvido para rodar em Android, Linux e Web.

---

## 🚀 Como Rodar o Projeto

Para executar este projeto em sua máquina local, siga os passos abaixo.

### Pré-requisitos

Antes de começar, certifique-se de que você tem o seguinte instalado:

* **Flutter SDK:** [Guia oficial de instalação](https://flutter.dev/docs/get-started/install)
* **Git:** Para clonar o repositório.
* Um editor de código, como **VS Code** ou **Android Studio**.

### ⚙️ Instalação e Configuração

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/seu-usuario/custom-tetris.git](https://github.com/seu-usuario/custom-tetris.git)
    ```

2.  **Navegue até o diretório do projeto:**
    ```bash
    cd custom-tetris
    ```

3.  **Instale as dependências do Flutter:**
    ```bash
    flutter pub get
    ```

### 🎮 Executando a Aplicação

#### Para Windows, macOS, Android e Web

Após instalar as dependências, o projeto deve rodar sem configurações adicionais.

```bash
# O Flutter mostrará uma lista de dispositivos conectados.
# Escolha o de sua preferência (ex: Android, Chrome).
flutter run
```

#### Configuração Especial para Linux

O pacote de áudio (`audioplayers`) requer uma biblioteca de sistema chamada **GStreamer** para funcionar no Linux. Se você estiver em uma distribuição baseada em Debian/Ubuntu, instale as dependências necessárias com o seguinte comando:

```bash
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good
```
Após a instalação, limpe o cache do Flutter antes de executar:
```bash
flutter clean
flutter run
```

---

## 🛠️ Tecnologias Utilizadas

* **[Flutter](https://flutter.dev/)**: Framework principal para o desenvolvimento da UI e da lógica.
* **[Dart](https://dart.dev/)**: Linguagem de programação utilizada.
* **[audioplayers](https://pub.dev/packages/audioplayers)**: Pacote para gerenciamento de música e efeitos sonoros.
* **[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)**: Utilizado para gerar os ícones do aplicativo para Android e iOS.