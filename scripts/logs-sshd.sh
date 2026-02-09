#!/bin/bash

# ==============================================================================
# Nom du script : logs-sshd.sh
# Description    : Contrôle local des accès SSH (Design Harmonisé)
# ==============================================================================

# --- Configuration & Variables ---
AUTH_LOG="/var/log/auth.log"

source config.sh

# --- Fonctions de Design ---

function afficheTitre() {
    clear
    echo -e "${JAUNE}###########################################################################${NC}"
    if command -v figlet &> /dev/null; then
        figlet -f slant "$1" | sed 's/^/  /'
    else
        echo -e "  [ $1 ]"
    fi
    echo -e "${JAUNE}###########################################################################${NC}"
    echo ""
}

function verifierDroits() {
    if [[ $EUID -ne 0 ]]; then
       echo -e "  ${ROUGE}[!] Erreur : Ce script doit être exécuté en root.${NC}"
       read -p "  [Appuyer sur Entrée pour continuer]"
       exit 1
    fi
    # Vérification du service ssh ou sshd (selon la distro)
    if ! systemctl list-unit-files "sshd.service" &> /dev/null; then
        echo -e "  ${ROUGE}[!] Erreur : Le service SSHD est introuvable.${NC}"
        read -p "  [Appuyer sur Entrée pour continuer]"
        exit 1
    fi
}

# --- Logique Métier ---

function voirSuccess() {
    echo -e "${JAUNE}>>> Dernières connexions SSH réussies :${NC}"
    cat $AUTH_LOG | grep "ssh" | grep "Accepted" 
}

function voirEchecs() {
    echo -e "${ROUGE}>>> Tentatives de connexion échouées (Brute Force) :${NC}"
    cat $AUTH_LOG | grep "ssh" | grep -E "Failed|Invalid" 
}

function rechercherIP() {
    read -p "  Entrez l'IP SSH à rechercher : " ip
    [[ -z "$ip" ]] && return
    echo -e "\n${JAUNE}>>> Occurrences pour l'IP $ip :${NC}"
    cat $AUTH_LOG | grep "ssh" | grep "$ip" 
}

function supprimerLignesIP() {
    read -p "  Entrez l'IP à effacer des logs : " ip
    [[ -z "$ip" ]] && return
    sed -i "/$ip/d" "$AUTH_LOG"
    echo -e "  ${VERT}[OK] Traces de $ip supprimées de $AUTH_LOG.${NC}"
}

function viderLogs() {
    read -p "  Vider le fichier auth.log ? (o/N) : " confirmation
    if [[ "$confirmation" == "o" || "$confirmation" == "O" ]];then
        cat /dev/null > $AUTH_LOG > /dev/null 2>&1 
        echo -e "  ${VERT}[OK] Le fichier auth.log a été remis à zéro.${NC}"
    else
        echo -e "  ${ROUGE}Opération annulée.${NC}"
    fi
} 

function restartSSH() {
    systemctl restart sshd 2>/dev/null
    echo -e "  ${VERT}[OK] Service SSHD redémarré.${NC}"
}

# --- Menu Principal ---
verifierDroits

quitter=1
while [[ $quitter -ne 0 ]]; do
    afficheTitre "Logs-sshd"
    
    echo -e "  ${JAUNE}┌──────────────────────────────────────────────────┐${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}1)${NC} Voir les connexions réussies                 ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}2)${NC} Voir les tentatives échouées                 ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}3)${NC} Rechercher une IP                            ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}4)${NC} Supprimer les traces d'une IP                ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}5)${NC} Vider le fichier auth.log                    ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}6)${NC} Redémarrer le service SSHD                   ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}                                                  ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${ROUGE}0)${NC} Retour au menu principal                     ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}└──────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -p "  Action [0-6] : " choix
    
    case $choix in 
        1) clear; voirSuccess; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        2) clear; voirEchecs; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        3) clear; rechercherIP; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        4) clear; supprimerLignesIP; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        5) clear; viderLogs; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        6) clear; restartSSH; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        0) quitter=0; clear ;;
        *) echo -e "  ${ROUGE}Option invalide.${NC}"; sleep 1; clear ;;
    esac
done