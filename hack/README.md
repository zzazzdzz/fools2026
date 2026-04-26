# Hacking Challenge I - A cut above the rest

I work at quality assurance and testing department, and my boss always ensures that I give 101% of what I got. My records of reaching floor 100 are insufficient, and they don't make my KPIs go up anymore. I need something bigger. Can you create a password that encodes a finished run on floor 101?

# Hacking Challenge II - Certified hacker

Our previous attempts of creating a secure certificate validation system were not the best. However, we learned some excellent lessons from our experience back in 2022. First of all, block ciphers are evil, so we shouldn't use them. Second of all, generating certificates is evil, so we removed that functionality too. The only public functionality is verification.

Despite those changes, we still feel like there is some sort of weakness here. Can you somehow get hold of a valid gold certificate? We have included a Python replica of the certificate verifier (`c2.py`), but you shouldn't read its code if you want to approach the challenge. Instead, in case it would be useful to audit the source code, we share some relevant parts of the certificate verifier code, which we wrote in GBZ80 assembly (`c2.asm`). That should give you some idea about the verification logic.

# Hacking Challenge III - Ultra secure vault

You know the deal by now. Here's a Pokémon Blue save file (`c3.sav`). Can you find the correct password? Once you do, submit it as a completion code. Good luck!