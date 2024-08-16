# flutter_dio_api_integration

 Este projeto é fruto do curso de 'Flutter: utilizando o Dio para realizar a comunicação com Web API' da plataforma ALURA

 ## Introdução

Este projeto é uma continuação do estudo iniciado no projeto **"flutter_persistencia_drift_hive"**, onde foram exploradas diferentes técnicas de persistência de dados utilizando as bibliotecas DRIFT e HIVE no Flutter. Nesta fase, avançamos para incorporar a dependência ao DIO, uma poderosa biblioteca para comunicação HTTP. A adição do DIO ao projeto permite a integração com APIs e a manipulação de dados em tempo real, ampliando as capacidades de comunicação e persistência da aplicação.

No caso deste projeto, foi usado o Firebase Realtime Database, uma solução de banco de dados em tempo real da plataforma Firebase, para gerenciar e sincronizar os dados da aplicação de forma eficiente.

## Apresentação do projeto

![Apresentação do projeto em GIF](info/showApp.gif)


## Configurações do Ambiente

- Criação do banco de dados no Firebase

    - Antes de configurar a url do Firebase Realtime Database no app, é necessário criar um projeto no Firebase e obter a URL do banco de dados.

    - Na definição das regras de acesso, inclusão de um índice com o uso de ".indexOn": "name" permite que as consultas que filtram ou ordenam os dados baseados no campo "name" sejam executadas de forma mais eficiente.

- Criação do arquivo ".env" para configuração da url

   - No pasta 'assets' do projeto, crie um arquivo chamado .env. com a seguinte definição abaixo

    
![Apresentação da configuração da url](info/configuracao%20url.png)


- Atualização das dependências do projeto

   - Abra um prompt de comando na pasta do projeto **'flutter-listin'** e execute os seguintes comandos 'flutter clean' e 'flutter pub get' 


### Tópicos abordados no curso:

- Métodos HTTP básicos;
- Uso de cabeçalhos e parâmetros;
- Padronização de configurações;
- Desenvolvimento de um log;
- Configuração de interceptadores;
- Tratamento de erros;


 ## Funcionalidades estudadas no projeto

- Configurando o servidor (Realtime Database);
- Usando POST/PUT para adicionar e editar os dados do servidor;
- Usando o GET para obter informações do servidor;
- Usando o DELETE para remover dados do servidor;
- Configurando BaseOptions para cabeçalhos, timeouts e outras configurações;
- Enviando parâmetros para o servidor;
- Criando e usando interceptadores pra gerar um log auditável;
- Lidando com erros usando o DioException;
- Refatorando o código para boas práticas;   