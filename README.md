# 🚀 Code-Space: Remote Development Workspace with Code-Server

**Code-Space** is a **containerized remote workspace** based on [`code-server`](https://hub.docker.com/r/linuxserver/code-server), allowing you to run **VS Code in the browser** with pre-installed developer tools, system dependencies, and automation scripts.

## 🎯 Features

✅ **Browser-based VS Code**: Access your development environment from anywhere.  
✅ **Persistent workspace**: Store your projects outside the container for long-term usage.  
✅ **Pre-installed dependencies**: `wget`, `curl`, `build-essential`, `openssl`.  
✅ **Automated scripts**: Installs essential tools like Docker, Node.js, and Python.  
✅ **Customizable setup**: Easily modify installed packages, extensions, and settings.  
✅ **Dockerized & Portable**: Run it on any system with Docker installed.  

---

## 📥 Installation & Usage

### 🛠 **1. Clone the Repository**  
```sh
git clone https://github.com/YOUR_USERNAME/code-space.git
cd code-space
```

### 🛠 **2. Build & Run with Docker**  
```sh
docker build -t code-space .
docker run -d -p 8443:8443 --name code-space -v /home/dev/workspace:/workspace code-space
```

### 🐳 **3. Run with Docker Compose**  
```sh
docker-compose up -d --build
```

🔹 **Your workspace folder is mapped to `/workspace` inside the container**. This ensures your files are persistent even after restarting the container.

---

## ⚙️ Workspace Configuration

### **📂 Default Workspace Location**
By default, the workspace is mapped to:  
```sh
/home/dev/workspace
```
Inside the container, this is accessible as:  
```sh
/workspace
```
Any files you create in this directory will remain even after the container is stopped or rebuilt.

### **🔧 Customizing the Workspace**
You can change the workspace directory by modifying the `docker-compose.yml`:  
```yaml
volumes:
  - /your/custom/path:/workspace
```

---

## 📂 Directory Structure

```
📁 code-space/
 ├── 📄 Dockerfile            # Custom Docker image definition
 ├── 📄 docker-compose.yml    # Docker Compose configuration
 ├── 📂 workspace/            # Your projects & development files (persistent)
 ├── 📂 scripts/              # (Optional) Install scripts for development tools
```

---

## 🚀 Running Code-Space

Once the container is running, open your browser and go to:  
🔗 **http://localhost:8443**  

Log in with the password set in **`docker-compose.yml`** or **environment variables**.

---

## 🔧 Customization

### **Install Additional Packages**
Modify the `INSTALL_PACKAGES` variable inside `Dockerfile` to add more dependencies.  

```dockerfile
ENV INSTALL_PACKAGES="wget curl build-essential openssl git vim"
```

### **Run Custom Scripts**
You can modify or add new installation scripts inside the `scripts/` directory.  

```dockerfile
RUN wget -O /tmp/custom-setup.sh https://your-script-url.sh && \
    chmod +x /tmp/custom-setup.sh && \
    /tmp/custom-setup.sh && \
    rm /tmp/custom-setup.sh
```

### **Change Default Password**
Modify `docker-compose.yml` to set a custom password:  
```yaml
environment:
  PASSWORD: "your-secure-password"
```

---

## 📌 Stopping & Restarting

To **stop the container**:  
```sh
docker-compose down
```

To **restart with the latest changes**:  
```sh
docker-compose up -d --build
```

To **remove the container completely**:  
```sh
docker rm -f code-space
docker rmi code-space
```

---

## 🚀 Future Improvements
- [ ] Add more pre-installed **programming languages** (Go, Rust, Java, PHP).  
- [ ] Pre-configure **VS Code extensions** inside `code-server`.  
- [ ] Add **SSH access** for remote development.  
- [ ] Optimize **Docker image size**.  

---

## 📝 License
This project is **open-source** and available under the **MIT License**.

---

🚀 **Code-Space** lets you create a **fully customizable, cloud-based development workspace** in seconds! 💻✨

