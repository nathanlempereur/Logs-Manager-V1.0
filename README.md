# Logs-Manager V1.0 

Bienvenue dans le module **Logs-Manager** !
<img width="763" height="190" alt="image" src="https://github.com/user-attachments/assets/71e85a87-8eef-4ad7-8672-6924b8d7c234" />



Ce module est dédié à la surveillance, l'analyse et la maintenance des journaux système.

---

## Présentation

**Logs-Manager** est un tableau de bord interactif conçu pour centraliser la gestion des logs de vos services Linux. Il permet aux administrateurs de surveiller les accès, de détecter les erreurs et de nettoyer les traces inutiles en quelques clics.

---

## Fonctionnalités

<img width="789" height="607" alt="image" src="https://github.com/user-attachments/assets/35968781-fd7a-4bff-b077-064a1bbfe672" />


### 1. Analyse des Services
Le manager couvre les services critiques suivants :
- **Apache2** : Surveillance des erreurs 404 et des échecs d'authentification Web.
  <img width="779" height="513" alt="image" src="https://github.com/user-attachments/assets/ee35c8a0-62ae-4c60-b125-ab3f20c9f676" />

- **SSH (sshd)** : Visualisation des connexions réussies et des tentatives de brute-force.
  <img width="783" height="521" alt="image" src="https://github.com/user-attachments/assets/69ae2b59-2e7b-4291-88c8-02d36eb8e35f" />

- **Pure-FTPd** : Contrôle des accès FTP et des transferts.
  <img width="777" height="521" alt="image" src="https://github.com/user-attachments/assets/f711be6c-2eb1-4ccb-9ee8-91bf1f22e74f" />

- **MySQL / MariaDB** : Analyse des erreurs critiques et des avertissements de base de données.
  <img width="802" height="509" alt="image" src="https://github.com/user-attachments/assets/af27c1b9-a3b8-40a8-8457-b4d4d6ee9556" />

- **Fail2Ban** : Historique des bannissements et des déblocages d'IP.
  <img width="787" height="511" alt="image" src="https://github.com/user-attachments/assets/9dd3b9c4-b510-4841-b9ce-3052f8a7119d" />

- **Postfix** : Monitoring des flux mails (envois, rejets et erreurs).
  <img width="807" height="509" alt="image" src="https://github.com/user-attachments/assets/d7fb0366-c469-4852-ad72-7d0a5a486b06" />



### 2. Outils de Maintenance
- **Recherche par IP** : Identification rapide de l'activité d'une adresse spécifique sur tous les services.
- **Nettoyage (Truncate)** : Remise à zéro sécurisée des fichiers de logs pour libérer de l'espace disque.
- **Gestion des traces** : Suppression ciblée des lignes liées à une IP spécifique dans les fichiers de logs.
- **Contrôle des services** : Possibilité de redémarrer les services directement depuis l'interface.


### 3. Design & Accessibilité
- **Interface Box-Design** : Menus encadrés et structurés pour une clarté optimale.
- **Mode Daltonien** : Schéma de couleurs adapté (Bleu/Cyan/Magenta) pour remplacer le Rouge/Vert.

---

## Installation & Utilisation

Le module détecte automatiquement si la configuration est manquante et exécute donc l'installateur.
<img width="784" height="693" alt="1" src="https://github.com/user-attachments/assets/0ccfe380-f65c-4eaa-a3d8-322049223048" />


### Téléchargement
git git@github.com:nathanlempereur/Logs-Manager-V1.0.git

### Lancement
sudo ./logs-manager.sh


---

## Informations !!

L'utilisation de cet outil est optimisée pour :
- **OS** : Linux avec gestionnaire de paquets APT (Debian/Ubuntu).
- **Droits** : Accès Root obligatoire pour la lecture de `/var/log/`.

---

## Contribution & Licence

Ce module est **open-source**. Vous pouvez le modifier et proposer des améliorations via des **Pull Requests**.

**Licence** : Ce projet est sous licence libre. 
**Contact** : contact@nlempereur.ovh

---
Merci d'utiliser **Logs-Manager** ! 🚀

https://logs-manager.nlempereur.ovh
