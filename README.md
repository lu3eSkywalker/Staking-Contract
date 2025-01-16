# Staking Contract

### Summary
In this repository, we use **three different approaches** to create staking contracts.

---

#### Approach 1:
Issues users an ERC-20 token based on the time they are staking ETH.

##### Implementation Architecture:
<img src="https://github.com/user-attachments/assets/f578db69-aaf2-4a46-8c25-32963c305a43" alt="Implementation Architecture" width="750" />

---

#### Approach 2:
Locks the tokens for the user during withdrawal for **21 days**.  
Users don’t receive the new token during this period.

##### Implementation Architecture:
<img src="https://github.com/user-attachments/assets/a68155da-5f3c-4f2c-98d1-9ef017697310" alt="Implementation Architecture" width="700" />

---

#### Approach 3:
Stakes an **ERC-20 token** instead of native ETH.

##### Implementation Architecture:
<img src="https://github.com/user-attachments/assets/1ae5f788-8a3f-4b93-bb87-5315fc31d369" alt="Implementation Architecture" width="700" />
