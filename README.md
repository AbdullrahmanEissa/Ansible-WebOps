# 🌐 Bio Website Deployment with Ansible on AWS

![Banner](https://img.shields.io/badge/Ansible-Automation-blue?style=for-the-badge&logo=ansible)
![AWS](https://img.shields.io/badge/AWS-Cloud-orange?style=for-the-badge&logo=amazon-aws)
![Nginx](https://img.shields.io/badge/Nginx-WebServer-green?style=for-the-badge&logo=nginx)
![Apache](https://img.shields.io/badge/Apache-WebServer-red?style=for-the-badge&logo=apache)

---

## 🚀 Project Overview

This project automates the deployment of my **Bio Website** using **Ansible**, across multiple **AWS EC2 instances**, with **load balancing** handled by an **AWS Application Load Balancer (ALB)**.  

The setup supports **high availability**, **scalability**, and **easy updates** via Git.  

---

## 🖥️ Architecture Diagram

```

```
   ┌─────────────┐
   │   AWS ALB   │
   └─────┬───────┘
         │
```

┌───────────┴───────────┐
│                       │
EC2 Instance 1       EC2 Instance 2 ... (total 5)
│                       │
Nginx / Apache Web Servers
│
Website served from GitHub Repo

````

---

## ⚡ Key Features

- **Multi-Instance Deployment:** 5 EC2 instances for redundancy.
- **Load Balancing:** AWS ALB distributing traffic across 3 web servers.
- **Automated Setup:** Nginx and Apache installed and configured via Ansible.
- **Git Integration:** Website pulled directly from GitHub.
- **Zero-Downtime Updates:** Index.html can be updated seamlessly.
- **Monitoring Ready:** Prepped for remote troubleshooting and metrics.

---

## 🛠️ Technologies Used

| Category        | Technology / Tool                     |
|-----------------|--------------------------------------|
| Infrastructure  | AWS EC2, AWS ALB                      |
| Automation      | Ansible                               |
| Web Servers     | Nginx, Apache2                         |
| Version Control | Git, GitHub                           |
| OS              | Ubuntu 22.04 LTS                       |
| Monitoring      | Netdata (optional setup)              |

---

## 📦 Ansible Playbooks

### Nginx Playbook (`nginx.yml`)

- Updates apt cache
- Installs Nginx
- Clones GitHub repository
- Moves `index.html` to `/usr/share/nginx/html`
- Restarts Nginx

```yaml
- hosts: all
  become: true
  tasks:
    - name: Update apt cache
      apt:
        update_cache: yes
    - name: Install Nginx
      apt:
        name: nginx
        state: latest
    - name: Clone GitHub repo
      git:
        repo: "https://github.com/AbdullrahmanEissa/My-Bio-Website.git"
        dest: /usr/share/nginx/html/My-Bio-Website
        version: main
        force: yes
    - name: Copy index.html
      copy:
        src: /usr/share/nginx/html/My-Bio-Website/index.html
        dest: /usr/share/nginx/html/index.html
        remote_src: yes
    - name: Restart Nginx
      ansible.builtin.systemd:
        name: nginx
        state: restarted
````

### Apache2 Playbook (`apache.yml`)

* Installs Apache2
* Clones GitHub repository
* Moves `index.html` to `/var/www/html`
* Restarts Apache2

```yaml
- hosts: all
  become: true
  tasks:
    - name: Install Apache2
      apt:
        name: apache2
        state: latest
    - name: Clone GitHub repo
      git:
        repo: "https://github.com/AbdullrahmanEissa/My-Bio-Website.git"
        dest: /var/www/html/My-Bio-Website
        version: main
        force: yes
    - name: Move index.html to Apache root
      command: mv /var/www/html/My-Bio-Website/index.html /var/www/html/index.html
      args:
        removes: /var/www/html/index.html
    - name: Restart Apache2
      ansible.builtin.systemd:
        name: apache2
        state: restarted
```

---

## 🌐 Deployment Steps

1. Clone this repository to your local machine:

```bash
git clone https://github.com/AbdullrahmanEissa/My-Bio-Website.git
cd My-Bio-Website
```

2. Ensure your `inventory` file contains all EC2 instance IPs.
3. Run the playbook:

```bash
ansible-playbook -i inventory nginx.yml   # For Nginx
ansible-playbook -i inventory apache.yml # For Apache
```

4. Access your website via **AWS ALB DNS** or directly via EC2 IP.

---

## 🔧 Future Enhancements

* Auto-scaling groups for EC2
* SSL/TLS with Let’s Encrypt
* CI/CD pipeline for automatic GitHub deployments
* Monitoring dashboard with Netdata
* Docker containerization of the web app

---

## 📈 Screenshots

![Screenshot 1](https://via.placeholder.com/600x300?text=Home+Page)
![Screenshot 2](https://via.placeholder.com/600x300?text=Projects+Section)
![Screenshot 3](https://via.placeholder.com/600x300?text=Resume+Section)

---

## 📝 Author

**Abdullrahman Eissa** – Linux System Administrator | DevOps Enthusiast
[GitHub](https://github.com/AbdullrahmanEissa) | [LinkedIn](https://www.linkedin.com/in/abdullrahman-eissa/)

---

## ⭐ License

This project is licensed under the [MIT License](LICENSE).

---

```
