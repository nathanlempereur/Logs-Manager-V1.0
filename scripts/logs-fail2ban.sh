#!/bin/bash

# ==============================================================================
# Nom du script : logs-fail2ban.sh
# Description    : Gestionnaire des bannissements Fail2Ban (Design Harmonisé)
# ==============================================================================

# --- Configuration & Variables ---
F2B_LOG="/var/log/fail2ban.log"

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
       echo -e "  ${ROUGE}[!] Erreur : Exécution en root requise.${NC}"
       read -p "  [Appuyer sur Entrée pour continuer]"
       exit 1
    fi
    if ! systemctl list-unit-files "fail2ban.service" &> /dev/null; then
        echo -e "  ${ROUGE}[!] Erreur : Le service Fail2Ban est introuvable.${NC}"
        read -p "  [Appuyer sur Entrée pour continuer]"
        exit 1
    fi
}

# --- Logique Métier ---

function voirBans() {
    echo -e "${JAUNE}>>> Dernières IPs bannies (Ban) :${NC}"
    cat "$F2B_LOG" | grep "Ban"
}

function voirUnbans() {
    echo -e "${JAUNE}>>> IPs débloquées (Unban) :${NC}"
    cat "$F2B_LOG" | grep "Unban"
}

function rechercherIP() {
    read -p "  Entrez l'IP à rechercher dans l'historique : " ip
    [[ -z "$ip" ]] && return
    echo -e "\n${JAUNE}>>> Historique pour l'IP $ip :${NC}"
    cat "$F2B_LOG" | grep "$ip"
}

function viderLogs() {
    read -p "  Vider le fichier fail2ban.log ? (o/N) : " confirmation
    if [[ "$confirmation" == "o" || "$confirmation" == "O" ]]; then
        cat /dev/null > "$F2B_LOG" > /dev/null 2>&1
        echo -e "  ${VERT}[OK] Logs Fail2Ban réinitialisés.${NC}"
    else
        echo -e "  Opération annulée."
    fi
}

function restartF2B() {
    systemctl restart fail2ban > /dev/null 2>&1
    echo -e "  ${VERT}[OK] Service Fail2Ban redémarré.${NC}"
}

# --- Menu Principal ---
verifierDroits

quitter=1
while [[ $quitter -ne 0 ]]; do
    afficheTitre "Logs-Fail2Ban"
    
    echo -e "  ${JAUNE}┌──────────────────────────────────────────────────┐${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}1)${NC} Voir les bannissements récents               ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}2)${NC} Voir les IPs débloquées                      ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}3)${NC} Rechercher une IP précise                    ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}4)${NC} Vider le fichier fail2ban.log                ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}5)${NC} Redémarrer le service Fail2Ban               ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}                                                  ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${ROUGE}0)${NC} Retour au menu principal                     ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}└──────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -p "  Action [0-5] : " choix
    
    case $choix in 
        1) clear; voirBans; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        2) clear; voirUnbans; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        3) clear; rechercherIP; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        4) clear; viderLogs; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        5) clear; restartF2B; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        0) quitter=0; clear ;;
        *) echo -e "  ${ROUGE}Option invalide.${NC}"; sleep 1; clear ;;
    esac
done