#!/bin/bash

# ==============================================================================
# Nom du script : logs-postfix.sh
# Description    : Gestionnaire des logs Mail Postfix (Design Harmonisé)
# ==============================================================================

# --- Configuration & Variables ---
# Sur Debian/Ubuntu, Postfix écrit dans mail.log
MAIL_LOG="/var/log/mail.log"

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
    if ! systemctl list-unit-files "postfix.service" &> /dev/null; then
        echo -e "  ${ROUGE}[!] Erreur : Le service Postfix est introuvable.${NC}"
        read -p "  [Appuyer sur Entrée pour continuer]"
        exit 1
    fi
}

# --- Logique Métier ---

function voirEnvois() {
    echo -e "${VERT}>>> Emails envoyés avec succès (status=sent) :${NC}"
    cat "$MAIL_LOG" | grep "status=sent"
}

function voirErreurs() {
    echo -e "${ROUGE}>>> Erreurs et Rejets (Reject/Bounced) :${NC}"
    cat "$MAIL_LOG" | grep -E "reject|bounced|error"
}

function rechercherIP() {
    read -p "  Entrez l'IP ou le domaine à rechercher : " cible
    [[ -z "$cible" ]] && return
    echo -e "\n${JAUNE}>>> Historique pour $cible :${NC}"
    cat "$MAIL_LOG" | grep "$cible"
}

function viderLogs() {
    read -p "  Vider le fichier mail.log ? (o/N) : " confirmation
    if [[ "$confirmation" == "o" || "$confirmation" == "O" ]]; then
        cat /dev/null > "$MAIL_LOG"
        echo -e "  ${VERT}[OK] Logs Mail réinitialisés.${NC}"
    else
        echo -e "  Opération annulée."
    fi
}

function restartPostfix() {
    systemctl restart postfix > /dev/null 2>&1
    echo -e "  ${VERT}[OK] Service Postfix redémarré.${NC}"
}

# --- Menu Principal ---
verifierDroits

quitter=1
while [[ $quitter -ne 0 ]]; do
    afficheTitre "Logs-Postfix"
    
    echo -e "  ${JAUNE}┌──────────────────────────────────────────────────┐${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}1)${NC} Voir les emails envoyés                      ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}2)${NC} Voir les erreurs et rejets                   ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}3)${NC} Rechercher une IP ou un domaine              ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}4)${NC} Vider le fichier mail.log                    ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}5)${NC} Redémarrer le service Postfix                ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}                                                  ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${ROUGE}0)${NC} Retour au menu principal                     ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}└──────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -p "  Action [0-5] : " choix
    
    case $choix in 
        1) clear; voirEnvois; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        2) clear; voirErreurs; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        3) clear; rechercherIP; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        4) clear; viderLogs; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        5) clear; restartPostfix; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        0) quitter=0; clear ;;
        *) echo -e "  ${ROUGE}Option invalide.${NC}"; sleep 1; clear ;;
    esac
done