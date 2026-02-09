# Logs-Manager V1.0 

Bienvenue dans le module **Logs-Manager** !
Ce module est dédié à la surveillance, l'analyse et la maintenance des journaux système.

---

## Présentation

**Logs-Manager** est un tableau de bord interactif conçu pour centraliser la gestion des logs de vos services Linux. Il permet aux administrateurs de surveiller les accès, de détecter les erreurs et de nettoyer les traces inutiles en quelques clics.

---

## Fonctionnalités

### 1. Analyse des Services
Le manager couvre les services critiques suivants :
- **Apache2** : Surveillance des erreurs 404 et des échecs d'authentification Web.
- **SSH (sshd)** : Visualisation des connexions réussies et des tentatives de brute-force.
- **Pure-FTPd** : Contrôle des accès FTP et des transferts.
- **MySQL / MariaDB** : Analyse des erreurs critiques et des avertissements de base de données.
- **Fail2Ban** : Historique des bannissements et des déblocages d'IP.
- **Postfix** : Monitoring des flux mails (envois, rejets et erreurs).


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

### Téléchargement
git git@github.com:nathanlempereur/Logs-Manager-V1.0.git

### Lancement
sudo ./logs-manager.sh

*Note : Lors du premier lancement, l'installateur configurera votre profil (nom et mode de couleur) et installera les dépendances (figlet).*

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
