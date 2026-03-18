# 🚀 AWS EC2 Deployment Guide

This document explains how I deployed my Docker application on AWS EC2.

---

## 🧱 Step 1: Launch EC2 Instance

- AMI: Ubuntu
- Instance Type: t3.micro
- Key Pair: gk-asia-sydney-ap-southeast-2.pem
- Security Group:
  - SSH (22)
  - HTTP (80)

---

## 🔐 Step 2: Connect to EC2

ssh -i gk-asia-sydney-ap-southeast-2.pem ubuntu@13.210.176.144

---

## ⚙️  Step 3: Install Docker

sudo apt update
sudo apt install docker.io -y
sudo systemctl is-active docker

---

## 📦 Step 4: Pull Docker Image

docker pull gkclouddevops/gokul-nginx

---

## 🚀 Step 5: Run Container

docker run -d -p 80:80 gkclouddevops/gokul-nginx

---

## 🌍 Step 6: Access Application

Open in browser:

- http://13.210.176.144

---

## ⚠️ Issues Faced & Fixes

SSH permission error → Fixed using chmod 400

Site not loading → Fixed by allowing HTTP (80) in security group

---

## 🎯 Outcome

Successfully deployed a Dockerized application on AWS EC2 and exposed it via public IP.

---
