#!/bin/bash

# Couleurs temporaires pour l'installateur
JAUNE='\033[1;33m'
ROUGE='\033[0;31m'
VERT='\033[0;32m'
BLANC='\033[0;37m'
NC='\033[0m'

# --- Vérification Root ---
if [[ $EUID -ne 0 ]]; then
    echo -e "${ROUGE} [!] Erreur : Ce script doit être exécuté en root.${NC}"
    exit 1
fi

clear
echo -e "${JAUNE}###########################################################################${NC}"
echo -e "${JAUNE}#                                                                         #${NC}"
echo -e "${JAUNE}#                INSTALLATION DE LOGS-MANAGER V1.0                        #${NC}"
echo -e "${JAUNE}#                                                                         #${NC}"
echo -e "${JAUNE}###########################################################################${NC}"
echo ""
sleep 2

# --- Configuration Utilisateur ---
echo -e "${BLANC}[1/3] Configuration du profil${NC}"
echo -e "${JAUNE}---------------------------------------------------------------------------${NC}"
read -p "  > Comment voulez-vous vous appeler ? : " name
echo ""
sleep 2

read -p "  > Activer le mode daltonien ? (Oui: 1; Non: 0) : " couleur
while [[ "$couleur" != "0" && "$couleur" != "1" ]]; do
    echo -e "  ${ROUGE}Saisie incorrecte.${NC}"
    read -p "  > Activer le mode daltonien ? (Oui: 1; Non: 0) : " couleur
done
echo ""
sleep 3

# --- Génération du fichier config.sh ---
echo -e "${BLANC}[2/3] Création du fichier de configuration...${NC}"

echo "nom=\"$name\"
version='1.0'" > config.sh

if [[ $couleur -eq 0 ]]; then
    echo "
# Couleurs Standards
JAUNE='\033[1;33m'
ROUGE='\033[0;31m'
VERT='\033[0;32m'
BLANC='\033[0;37m'
NC='\033[0m'" >> config.sh
else
    echo "
# Couleurs Daltonien
JAUNE='\033[1;34m' 
ROUGE='\033[1;35m' 
VERT='\033[1;36m' 
BLANC='\033[0;37m' 
NC='\033[0m'" >> config.sh
fi

source config.sh
echo -e "  ${VERT}[OK]${NC} Fichier config.sh généré."
echo ""
sleep 2

# --- Installation des dépendances ---
echo -e "${BLANC}[3/3] Installation des paquets requis...${NC}"
echo -e "${JAUNE}---------------------------------------------------------------------------${NC}"
sleep 2

# Simulation de progression et installation réelle
echo -ne "  Mise à jour des dépôts...           "
apt update -y > /dev/null 2>&1 && sleep 5 && echo -e "${VERT}[DONE]${NC}" || echo -e "${ROUGE}[FAIL]${NC}"
sleep 2

echo -ne "  Installation de Figlet...           "
apt install -y figlet > /dev/null 2>&1 && sleep 5 && echo -e "${VERT}[DONE]${NC}" || echo -e "${ROUGE}[FAIL]${NC}"
sleep 2

if [[ $? -eq 0 ]]; then
    echo ""
    echo -e "${JAUNE}###########################################################################${NC}"
    echo -e "${VERT}            INSTALLATION TERMINÉE AVEC SUCCÈS !${NC}"
    echo -e "${JAUNE}###########################################################################${NC}"
    echo ""
    echo -e "  Utilisateur : ${VERT}$nom${NC}"
    echo -e "  Mode Couleur : ${VERT}$( [[ $couleur -eq 1 ]] && echo "Daltonien" || echo "Standard" )${NC}"
    echo ""
    read -p "[Appuyer sur Entrée pour lancer le manager]"
    clear
else
    echo -e "${ROUGE}Une erreur est survenue durant l'installation.${NC}"
    exit 2
fi