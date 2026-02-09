#!/bin/bash

# ==============================================================================
# Nom du script : logs-manager.sh
# Description    : Accueil Dashboard SrvTools
# ==============================================================================

# Sécurité installation
if [[ ! -f config.sh ]]; then
    bash install/install.sh
fi
if [[ $? -ne 0 ]]; then
    exit 0
fi 

# Import des configurations (Couleurs et variables)
source config.sh

# --- Fonctions de Design ---

function afficheTitre() {
    clear
    echo -e "${JAUNE}###########################################################################${NC}"
    if command -v figlet &> /dev/null; then
        figlet -f slant "$1" | sed 's/^/  /' # Décale le titre pour l'alignement
    else
        echo -e "  [ $1 ]"
    fi
    echo -e "${JAUNE}###########################################################################${NC}"
    echo ""
}

function verifierDroits() {
    if [[ $EUID -ne 0 ]]; then
       echo -e "${ROUGE} [!] ERREUR : Privilèges Root requis.${NC}"
       exit 1
    fi
}

# --- Initialisation ---
verifierDroits

quitter=1
while [[ $quitter -ne 0 ]]; do
    # Affichage du header
    afficheTitre "Logs-Manager"
    
    # Barre d'infos système
    echo -e "  ${BLANC}Utilisateur : ${JAUNE}$nom${NC} | ${BLANC}Version : ${VERT}$version${NC}"
    echo -e "  ${BLANC}Serveur : ${VERT}$(hostname)${NC}"
    echo -e "${JAUNE}---------------------------------------------------------------------------${NC}"
    echo ""
    
    # Menu stylisé
    echo -e "  ${JAUNE}┌──────────────────────────────────────────────────┐${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}1)${NC} Analyser les logs ${BLANC}Apache2${NC}                    ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}2)${NC} Analyser les logs ${BLANC}SSH (sshd)${NC}                 ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}3)${NC} Analyser les logs ${BLANC}FTP (Pure-FTPd)${NC}            ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}4)${NC} Analyser les logs ${BLANC}MySQL / MariaDB${NC}            ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}5)${NC} Analyser les logs ${BLANC}Fail2Ban (Bans)${NC}            ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${VERT}6)${NC} Analyser les logs ${BLANC}Mail (Postfix)${NC}             ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}                                                  ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}│${NC}  ${ROUGE}0)${NC} Quitter le manager                           ${JAUNE}│${NC}"
    echo -e "  ${JAUNE}└──────────────────────────────────────────────────┘${NC}"
    echo ""
    
    read -p "  Sélectionnez une option [0-6] : " choix
    
    case $choix in 
        1) bash scripts/logs-apache.sh ;;
        2) bash scripts/logs-sshd.sh ;;
        3) bash scripts/logs-ftpd.sh ;;
        4) bash scripts/logs-mysql.sh ;;
        5) bash scripts/logs-fail2ban.sh ;;
        6) bash scripts/logs-postfix.sh ;;
        0) 
            quitter=0 
            echo -e "\n  ${VERT}Fermeture du manager...${NC}"
            sleep 1
            clear
            ;;
        *) 
            echo -e "\n  ${ROUGE}Option [$choix] invalide !${NC}"
            sleep 1
            ;;
    esac

done
