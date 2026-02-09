#!/bin/bash

# ==============================================================================
# Nom du script : logs-mysql.sh
# Description    : Gestionnaire de logs MySQL/MariaDB (Design Harmonisé)
# ==============================================================================

# --- Configuration & Variables ---
# Chemin par défaut sur Debian/Ubuntu
MYSQL_LOG="/var/log/mysql/error.log"

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
    # Vérification de l'existence du service (mysql ou mariadb)
    if ! systemctl list-unit-files "mysql.service" > /dev/null 2>&1 && ! systemctl list-unit-files "mariadb.service" > /dev/null 2>&1; then
        echo -e "  ${ROUGE}[!] Erreur : Le service MySQL/MariaDB est introuvable.${NC}"
        read -p "  [Appuyer sur Entrée pour continuer]"
        exit 1
    fi
}

# --- Logique Métier ---

function voirErreurs() {
    echo -e "${JAUNE}>>> Dernières erreurs MySQL détectées :${NC}"
    cat "$MYSQL_LOG" | grep "\[ERROR\]"
}

function voirWarnings() {
    echo -e "${JAUNE}>>> Alertes (Warnings) système :${NC}"
    cat "$MYSQL_LOG" | grep "\[Warning\]"
}

function rechercherIP() {
    read -p "  Entrez l'adresse IP à rechercher dans les logs : " ip
    [[ -z "$ip" ]] && return
    echo -e "\n${JAUNE}>>> Occurrences pour l'IP $ip :${NC}"
    cat "$MYSQL_LOG" | grep "$ip"
}

function viderLogs() {
    read -p "  Vider le fichier error.log MySQL ? (o/N) : " confirmation
    if [[ "$confirmation" == "o" || "$confirmation" == "O" ]]; then
        cat /dev/null > "$MYSQL_LOG" > /dev/null 2>&1 
        echo -e "  ${VERT}[OK] Log MySQL remis à zéro.${NC}"
    else
        echo -e "  Opération annulée."
    fi
}

function restartMySQL() {
    # On teste quel service est installé pour redémarrer le bon
    if systemctl list-unit-files "mariadb.service" &> /dev/null; then
        systemctl restart mariadb > /dev/null 2>&1
    else
        systemctl restart mysql > /dev/null 2>&1
    fi
    echo -e "  ${VERT}[OK] Service Base de données redémarré.${NC}"
}

# --- Menu Principal ---
verifierDroits

quitter=1
while [[ $quitter -ne 0 ]]; do
    afficheTitre "Logs-MySQL"
    
    echo -e "  ${JAUNE}┌──────────────────────────────────────────────────┐${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}1)${NC} Voir les erreurs critiques ([ERROR])         ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}2)${NC} Voir les avertissements ([Warning])          ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}3)${NC} Rechercher une IP                            ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}4)${NC} Vider le fichier error.log                   ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}5)${NC} Redémarrer le service MySQL/MariaDB          ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}                                                  ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${ROUGE}0)${NC} Retour au menu principal                     ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}└──────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -p "  Action [0-5] : " choix
    
    case $choix in 
        1) clear; voirErreurs; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        2) clear; voirWarnings; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        3) clear; rechercherIP; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        4) clear; viderLogs; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        5) clear; restartMySQL; echo -e "\n${BLANC}[Entrée pour continuer]${NC}"; read; clear ;;
        0) quitter=0; clear ;;
        *) echo -e "  ${ROUGE}Option invalide.${NC}"; sleep 1; clear ;;
    esac
done