#!/bin/bash

# ==============================================================================
# Nom du script : logs-apache.sh
# Description    : Gestionnaire de logs Apache2 (Design Harmonisé)
# ==============================================================================

# --- Configuration & Variables ---
LOG_DIR="/var/log/apache2"
ACCESS_LOG="$LOG_DIR/access.log"
ERROR_LOG="$LOG_DIR/error.log"

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
    if ! systemctl list-unit-files "apache2.service" &> /dev/null; then
        echo -e "  ${ROUGE}[!] Erreur : Le service Apache2 est introuvable.${NC}"
        read -p "  [Appuyer sur Entrée pour continuer]"
        exit 1
    fi
}

# --- Logique Métier ---

function voir404() {
    echo -e "${JAUNE}>>> Dernières erreurs 404 détectées :${NC}"
    cat "$ERROR_LOG" | grep "File does not exist:" 
}

function voirEchecsAuth() {
    echo -e "${JAUNE}>>> Tentatives de connexion échouées (Auth) :${NC}"
    cat "$ERROR_LOG" | grep "not found:" 
}

function rechercherIP() {
    read -p "  Entrez l'adresse IP à rechercher : " ip
    [[ -z "$ip" ]] && return
    echo -e "\n${JAUNE}>>> Occurrences pour l'IP $ip :${NC}"
    cat "$ERROR_LOG" | grep "$ip" 
}

function supprimerLignesIP() {
    read -p "  Entrez l'IP à supprimer : " ip
    [[ -z "$ip" ]] && return
    cp "$ACCESS_LOG" "${ACCESS_LOG}.bak"
    sed -i "/$ip/d" "$ACCESS_LOG"
    echo -e "  ${VERT}[OK] Traces de $ip supprimées de $ACCESS_LOG.${NC}"
}

function viderLogs() {
    read -p "  Vider le fichier error.log ? (o/N) : " confirmation
    # CORRECTION ICI : Ajout du "then" manquant
    if [[ "$confirmation" == "o" || "$confirmation" == "O" ]]; then
        cat /dev/null > "$ERROR_LOG" 
        echo -e "  ${VERT}[OK] Fichier de logs remis à zéro.${NC}"
    else
        echo -e "  Opération annulée."
    fi
}

function restartApache() {
    systemctl restart apache2 > /dev/null 2>&1
    echo -e "  ${VERT}[OK] Service Apache2 redémarré.${NC}"
}

# --- Menu Principal ---
verifierDroits

quitter=1
while [[ $quitter -ne 0 ]]; do
    afficheTitre "Logs-Apache2"
    
    echo -e "  ${JAUNE}┌──────────────────────────────────────────────────┐${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}1)${NC} Voir les erreurs 404                         ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}2)${NC} Voir les échecs d'authentification           ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}3)${NC} Rechercher par IP                            ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}4)${NC} Supprimer les lignes d'une IP                ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}5)${NC} Vider le fichier error.log                   ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}6)${NC} Redémarrer le service Apache                 ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}                                                  ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${ROUGE}0)${NC} Retour au menu principal                     ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}└──────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -p "  Action [0-6] : " choix
    
    case $choix in 
        1) clear; voir404; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        2) clear; voirEchecsAuth; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        3) clear; rechercherIP; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        4) clear; supprimerLignesIP; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        5) clear; viderLogs; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        6) clear; restartApache; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        0) quitter=0; clear ;;
        *) echo -e "  ${ROUGE}Option invalide.${NC}"; sleep 1; clear ;;
    esac
done