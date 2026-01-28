Bom essa pasta ta um pouco confusa, mas faz sentido depois de uma explicação

ela está organizada assim:

===========================================
\ systems
    |
    | -> \ collision
    |       |
    |       | -> \ collision.lua
    |       | -> \ interaction.lua
    |       | -> \ physics.lua
    |
    | -> \ map
    |       |
    |       | -> generator.lua
===========================================

    O arquivo 'collision.lua' é responsável por fazer a verificação de
todas as entidades principais para colidir e o personagem parar de andar


    O arquivo 'physics.lua' é responsável por ter todas as lógica de A>B 
ou de raio para retornar um 'true' ou 'false' se os valores colidirem,
só a equação no caso

--> o 'collision' depende do 'physics' para gerar resultado


    O arquivo 'interaction.lua' é responsável por verificar raio de 
interação e mandar ativar alguma coisa que for usada