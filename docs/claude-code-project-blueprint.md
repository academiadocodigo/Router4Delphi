# Claude Code Project Blueprint

> **O que e isso?** Um guia completo para configurar qualquer projeto com Claude Code usando a mesma metodologia de qualidade profissional. Copie este arquivo, adapte as secoes marcadas com `[ADAPTAR]` para seu projeto, e entregue ao Claude Code com o comando:
>
> _"Use este blueprint para configurar a estrutura completa de qualidade do projeto."_

---

## 1. Estrutura de Diretorios

Crie esta arvore de diretorios no projeto:

```
projeto/
  CLAUDE.md                    # Guia principal (arquitetura, build, convencoes)
  CHANGELOG.md                 # Historico de mudancas
  src/                         # Codigo fonte
    CLAUDE.md                  # Regras especificas do codigo fonte
  tests/                       # Testes automatizados
  samples/                     # Projetos de exemplo
    CLAUDE.md                  # Regras para criar samples
  docs/                        # Documentacao publica
    CLAUDE.md                  # Regras da documentacao
    index.html                 # Documentacao navegavel
    plans/                     # Design docs e planos de implementacao
  .claude/
    rules/                     # Regras obrigatorias (executadas automaticamente)
    agents/                    # Agentes especializados
    skills/                    # Skills reutilizaveis (referencia de padroes)
      <skill-name>/
        SKILL.md
```

---

## 2. CLAUDE.md Principal (Raiz)

O CLAUDE.md da raiz e o mais importante. Ele da contexto global ao Claude Code.

```markdown
# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Projeto

[ADAPTAR] Descricao em 2-3 frases do que o projeto faz, qual problema resolve, e quem usa.

## Build e Execucao

[ADAPTAR] Comandos exatos para:
- Instalar dependencias
- Compilar o projeto
- Rodar testes
- Rodar um teste especifico
- Rodar o projeto localmente

## Estrutura do Repositorio

[ADAPTAR] Mapa das pastas principais com descricao de 1 linha cada.

## Arquitetura

[ADAPTAR] Descrever em alto nivel:
- Camadas principais (ex: Entity → Service → Repository → Database)
- Fluxo de dados (ex: Request → Middleware → Controller → Service → Response)
- Padroes centrais (ex: interfaces, dependency injection, fluent API)
- Integracao com servicos externos

## Convencoes

[ADAPTAR] Listar as convencoes de nomenclatura e organizacao do projeto:
- Nomes de arquivos, classes, funcoes, variaveis
- Organizacao de imports/uses
- Padrao de tratamento de erros

## Requisito Fundamental

Toda nova feature DEVE incluir:
1. Testes automatizados cobrindo comportamento e edge cases
2. Projeto de exemplo demonstrando o uso
3. Atualizacao da documentacao publica
4. Entrada no CHANGELOG antes do commit
```

---

## 3. CLAUDE.md por Diretorio

Cada diretorio com regras especificas recebe seu proprio CLAUDE.md.

### src/CLAUDE.md

```markdown
# CLAUDE.md — src/

Regras obrigatorias para todo codigo em src/.

## Padrao de Classe/Modulo

[ADAPTAR] Template da estrutura padrao que toda classe/modulo deve seguir.
Incluir: heranca, interfaces, construtor, exports.

## Interfaces/Contratos

[ADAPTAR] Onde ficam as interfaces/types/contracts.
Regra: centralizar em um unico arquivo ou diretorio.

## Nomenclatura

[ADAPTAR] Tabela de prefixos, sufixos, e convencoes especificas do codigo.

## Regras de Seguranca

[ADAPTAR] Regras inviolaveis: parametrizacao SQL, sanitizacao de input,
tratamento de excecoes, gerenciamento de memoria/recursos.
```

### samples/CLAUDE.md

```markdown
# CLAUDE.md — samples/

## Tipos de Arquivo

[ADAPTAR] Quais arquivos o Claude pode criar vs quais sao gerados por IDE/tooling.

## Estrutura Obrigatoria

Todo sample deve conter:
- Arquivo principal executavel
- README.md explicando o que demonstra e como rodar
- Reutilizar entidades/modelos compartilhados quando existirem

## Demonstracao Minima

[ADAPTAR] Toda sample deve demonstrar no minimo:
- Setup/configuracao
- Operacao principal da feature
- Output visivel (console log, HTTP response, etc)
```

### docs/CLAUDE.md

```markdown
# CLAUDE.md — docs/

## Estrutura de Planos

- Design docs: `plans/YYYY-MM-DD-<topico>-design.md` (fase de brainstorming)
- Planos de implementacao: `plans/YYYY-MM-DD-<topico>-plan.md` (execucao task-by-task)

## CHANGELOG

- Formato: Keep a Changelog (keepachangelog.com)
- Secoes: Added, Changed, Deprecated, Removed, Fixed
- Atualizar ANTES do commit

## Documentacao Publica

[ADAPTAR] Formato da documentacao (HTML, Markdown, Docusaurus, etc).
Regra: toda feature nova atualiza a documentacao.
```

---

## 4. Rules (Regras Obrigatorias)

Arquivos em `.claude/rules/` sao lidos automaticamente pelo Claude Code e aplicados como leis. Crie um arquivo por dominio.

### .claude/rules/testing.md

```markdown
---
description: Regras obrigatorias de testes para todo codigo novo
globs: ["src/**", "lib/**"]
---

# Testes Obrigatorios

Toda nova feature ou bugfix DEVE ter testes automatizados.
Feature sem teste e feature incompleta.

## Estrutura

[ADAPTAR]
- Diretorio: tests/
- Nomenclatura: test_<modulo>.ext ou <Modulo>Test.ext
- Nomes de teste: test_<funcionalidade>_<cenario>_<resultado_esperado>

## Cobertura Minima

- Comportamento principal (happy path)
- Edge cases (valores nulos, vazios, limites)
- Erros esperados (excecoes, validacoes)

## Regras

- Testes devem ser independentes (sem dependencia de ordem)
- Usar mocks para dependencias externas (DB, API, filesystem)
- Nao deixar memory leaks nos testes
```

### .claude/rules/code-quality.md

```markdown
---
description: Padroes de qualidade de codigo
globs: ["src/**", "lib/**"]
---

# Qualidade de Codigo

[ADAPTAR] Regras especificas da linguagem:

## Nomenclatura
- Arquivos: [padrao]
- Classes/Tipos: [padrao]
- Funcoes/Metodos: [padrao]
- Variaveis: [padrao]
- Constantes: [padrao]

## Estrutura
- [ADAPTAR] Ordem de imports
- [ADAPTAR] Padrao de classe (heranca, interface, construtor)
- [ADAPTAR] Padrao de tratamento de erro

## Proibido
- [ADAPTAR] Lista de anti-patterns especificos da linguagem
```

### .claude/rules/security.md

```markdown
---
description: Regras de seguranca inviolaveis
globs: ["**"]
---

# Seguranca

Estas regras NUNCA podem ser violadas.

## Injecao
- NUNCA concatenar input do usuario em queries (SQL, NoSQL, GraphQL)
- SEMPRE usar parametrizacao/prepared statements

## Recursos
- [ADAPTAR] Regras de gerenciamento de memoria/recursos
- Todo recurso aberto deve ter cleanup garantido (try/finally, defer, using, etc)

## Excecoes
- NUNCA engolir excecoes silenciosamente
- Sempre re-raise apos cleanup ou logar com contexto

## Segredos
- NUNCA hardcodar credenciais, tokens, ou chaves no codigo
- Usar variaveis de ambiente ou secret managers
```

### .claude/rules/changelog.md

```markdown
---
description: Documentacao obrigatoria de mudancas
globs: ["src/**", "lib/**"]
---

# CHANGELOG Obrigatorio

Toda alteracao de codigo DEVE ser documentada no CHANGELOG.md ANTES do commit.

## Formato

- Entrada: `- **NomeEmNegrito** - descricao breve (arquivo.ext)`
- Secoes: Added | Changed | Deprecated | Removed | Fixed

## Excecoes

Nao documentar: alteracoes em CHANGELOG.md, CLAUDE.md, docs/plans/, .claude/
```

### .claude/rules/documentation.md

```markdown
---
description: Atualizacao obrigatoria da documentacao publica
globs: ["src/**", "lib/**"]
---

# Documentacao Obrigatoria

Toda nova feature DEVE atualizar a documentacao publica.

[ADAPTAR] Formato e localizacao da documentacao.
- Adicionar secao com exemplo de uso
- Incluir referencia de API/parametros quando aplicavel
```

### .claude/rules/sample-creation.md

```markdown
---
description: Criacao obrigatoria de exemplos
globs: ["src/**", "lib/**"]
---

# Samples Obrigatorios

Toda nova feature DEVE ter um projeto de exemplo em samples/.

## Estrutura

[ADAPTAR]
- Diretorio: samples/<nome-da-feature>/
- Arquivo principal executavel
- README.md com instrucoes

## Conteudo Minimo

- Setup/configuracao
- Demonstracao da feature principal
- Output visivel para o desenvolvedor
```

---

## 5. Agents (Agentes Especializados)

Agentes sao sub-processos do Claude Code com escopo e ferramentas limitadas. Crie um por responsabilidade.

### .claude/agents/code-reviewer.md

```markdown
---
name: code-reviewer
description: Revisor de codigo que verifica conformidade com todas as regras do projeto
model: opus
tools: [Read, Glob, Grep, Bash]
skills: [coding-patterns]
---

# Code Reviewer

Voce e um revisor senior. Analise o codigo contra TODAS as regras em .claude/rules/.

## Processo

1. Leia todas as regras em .claude/rules/
2. Execute `git diff` para ver as mudancas
3. Verifique cada arquivo modificado contra cada regra
4. Classifique problemas: CRITICAL (viola regra) | IMPORTANT (deveria corrigir) | SUGGESTION (considerar)

## Output

Para cada problema:
```
[SEVERITY] arquivo:linha - descricao do problema
  Regra violada: rules/xxx.md
  Correcao: descricao da correcao
```
```

### .claude/agents/changelog-enforcer.md

```markdown
---
name: changelog-enforcer
description: Garante que o CHANGELOG esta atualizado antes de commits
model: sonnet
maxTurns: 5
tools: [Read, Edit, Bash, Grep, Glob]
skills: [changelog-format]
---

# Changelog Enforcer

## Processo

1. Leia .claude/rules/changelog.md
2. Execute `git diff --cached` ou `git diff` para ver mudancas
3. Leia CHANGELOG.md atual
4. Verifique se todas as mudancas estao documentadas
5. Adicione entradas faltantes na secao [Unreleased]
```

### .claude/agents/new-feature.md (Template Generico)

```markdown
---
name: new-feature
description: [ADAPTAR] Cria novos componentes seguindo os padroes do projeto
model: opus
tools: [Read, Write, Edit, Glob, Grep, Bash]
skills: [coding-patterns]
---

# New Feature Agent

## Antes de Criar

1. Leia as regras: code-quality.md, security.md, testing.md
2. Analise componentes similares existentes para seguir o padrao

## Checklist Obrigatorio

Apos criar o componente:
- [ ] Testes automatizados criados e passando
- [ ] Sample project criado em samples/
- [ ] Documentacao publica atualizada
- [ ] CHANGELOG.md atualizado
- [ ] Revisao contra todas as rules/
```

### .claude/agents/test-creator.md

```markdown
---
name: test-creator
description: Cria testes automatizados seguindo os padroes do projeto
model: sonnet
tools: [Read, Write, Edit, Glob, Grep, Bash]
skills: [coding-patterns]
---

# Test Creator

## Processo

1. Leia .claude/rules/testing.md
2. Analise o codigo a ser testado
3. Identifique: happy paths, edge cases, error cases
4. Crie testes seguindo a nomenclatura padrao
5. Verifique que testes sao independentes e sem side effects
```

### .claude/agents/sql-analyzer.md (Exemplo Dominio-Especifico)

```markdown
---
name: sql-analyzer
description: [ADAPTAR] Agente de dominio especifico para analise especializada
model: sonnet
maxTurns: 10
tools: [Read, Grep, Glob, Bash]
---

# Domain Analyzer

[ADAPTAR] Especialista em um dominio especifico do projeto.

## Analise

1. [ADAPTAR] O que analisar
2. [ADAPTAR] Contra quais regras verificar
3. [ADAPTAR] Formato do relatorio
```

---

## 6. Skills (Referencia de Padroes)

Skills sao documentos de referencia que agents e o Claude Code consultam. Ficam em `.claude/skills/<nome>/SKILL.md`.

### .claude/skills/coding-patterns/SKILL.md

```markdown
---
name: coding-patterns
description: Padroes de codigo e convencoes do projeto
---

# Padroes de Codigo

## Template de Classe/Modulo

[ADAPTAR] Template completo que toda classe/modulo deve seguir.
Incluir imports, heranca, construtor, metodos, exports.

## Nomenclatura

[ADAPTAR] Tabela de referencia rapida:
| Elemento    | Padrao        | Exemplo          |
|-------------|---------------|------------------|
| Arquivo     | [padrao]      | [exemplo]        |
| Classe      | [padrao]      | [exemplo]        |
| Interface   | [padrao]      | [exemplo]        |
| Funcao      | [padrao]      | [exemplo]        |
| Variavel    | [padrao]      | [exemplo]        |
| Constante   | [padrao]      | [exemplo]        |

## Tratamento de Erros

[ADAPTAR] Template padrao de error handling.

## Organizacao de Imports

[ADAPTAR] Ordem obrigatoria dos imports/uses.
```

### .claude/skills/memory-safety/SKILL.md (Se aplicavel)

```markdown
---
name: memory-safety
description: Padroes de gerenciamento de memoria e recursos
---

# Memory Safety

[ADAPTAR] Regras especificas da linguagem para:
- Alocacao e liberacao de recursos
- Ownership e lifetime
- Padroes de cleanup (try/finally, defer, using, RAII)
- Armadilhas comuns e como evitar
```

### .claude/skills/changelog-format/SKILL.md

```markdown
---
name: changelog-format
description: Formato do CHANGELOG
---

# CHANGELOG Format

## Estrutura

```
# Changelog

## [Unreleased]

### Added
- **NomeFeature** - descricao (arquivo.ext)

### Changed
- **NomeModificado** - o que mudou (arquivo.ext)

### Fixed
- **NomeBug** - o que foi corrigido (arquivo.ext)

## [1.0.0] - 2024-01-15
...
```
```

---

## 7. Como Aplicar ao Projeto

Entregue este blueprint ao Claude Code com uma destas instrucoes:

### Setup Completo (Projeto Novo)

```
Use o blueprint em docs/claude-code-project-blueprint.md para configurar
a estrutura completa de qualidade deste projeto. O projeto usa [LINGUAGEM]
com [FRAMEWORK]. Adapte todas as secoes marcadas [ADAPTAR] para este contexto.
Crie todos os arquivos: CLAUDE.md (raiz + subdiretorios), rules, agents, skills.
```

### Setup Completo (Projeto Existente)

```
Use o blueprint em docs/claude-code-project-blueprint.md para configurar
a estrutura de qualidade. Analise o projeto primeiro para entender a
arquitetura, padroes e convencoes existentes. Depois crie todos os arquivos
adaptados ao que ja existe. Nao mude o codigo existente, apenas adicione
a infraestrutura de qualidade.
```

### Adicionar Apenas Rules

```
Use a secao 4 (Rules) do blueprint para criar regras de qualidade
adaptadas a este projeto [LINGUAGEM/FRAMEWORK].
```

### Adicionar Apenas Agents

```
Use a secao 5 (Agents) do blueprint para criar agentes especializados
adaptados a este projeto [LINGUAGEM/FRAMEWORK].
```

---

## 8. Fluxo de Trabalho Resultante

Apos configurar tudo, o fluxo natural de trabalho com Claude Code sera:

```
1. Desenvolvedor pede nova feature
   ↓
2. Claude Code le CLAUDE.md + rules/ automaticamente
   ↓
3. Claude Code cria:
   - Codigo seguindo padroes (skills/coding-patterns)
   - Testes automatizados (rules/testing.md)
   - Sample project (rules/sample-creation.md)
   - Documentacao atualizada (rules/documentation.md)
   - CHANGELOG atualizado (rules/changelog.md)
   ↓
4. Code reviewer agent valida tudo contra as rules
   ↓
5. Commit com todas as garantias de qualidade
```

### Camadas de Garantia

| Camada | Mecanismo | Quando Atua |
|--------|-----------|-------------|
| **Rules** | Lidas automaticamente pelo Claude Code | Toda interacao |
| **CLAUDE.md** | Contexto global do projeto | Toda interacao |
| **Agents** | Sub-processos especializados | Sob demanda ou proativamente |
| **Skills** | Referencia de padroes | Consultados por agents e Claude Code |

### O Triangulo de Qualidade

Toda feature nova so e considerada completa quando tem:

```
        TESTES
       /      \
      /        \
   SAMPLE --- DOCS
```

- **Sem teste** = feature incompleta
- **Sem sample** = feature sem prova de uso
- **Sem docs** = feature invisivel

---

## 9. Checklist de Verificacao

Apos configurar, verifique que existe:

- [ ] `CLAUDE.md` na raiz com arquitetura e comandos de build
- [ ] `CLAUDE.md` em src/ com padroes de codigo
- [ ] `CLAUDE.md` em samples/ com regras de samples
- [ ] `CLAUDE.md` em docs/ com regras de documentacao
- [ ] `.claude/rules/testing.md`
- [ ] `.claude/rules/code-quality.md`
- [ ] `.claude/rules/security.md`
- [ ] `.claude/rules/changelog.md`
- [ ] `.claude/rules/documentation.md`
- [ ] `.claude/rules/sample-creation.md`
- [ ] `.claude/agents/code-reviewer.md`
- [ ] `.claude/agents/changelog-enforcer.md`
- [ ] `.claude/agents/new-feature.md` (adaptado ao dominio)
- [ ] `.claude/skills/coding-patterns/SKILL.md`
- [ ] `.claude/skills/changelog-format/SKILL.md`
- [ ] `CHANGELOG.md` inicializado
- [ ] `docs/` com documentacao publica
- [ ] `tests/` com pelo menos um teste
- [ ] `samples/` com pelo menos um exemplo
