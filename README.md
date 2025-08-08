# Processador MIPS Multiciclo

Este repositório contém a implementação de um **processador MIPS multiciclo** desenvolvido em VHDL. O projeto implementa uma versão simplificada da arquitetura MIPS usando uma abordagem multiciclo, onde diferentes tipos de instruções podem levar diferentes números de ciclos de clock para serem executadas.

## 📋 Visão Geral

O processador MIPS multiciclo é uma implementação que divide a execução das instruções em múltiplos ciclos de clock, permitindo o reuso de unidades funcionais e reduzindo a complexidade do hardware em comparação com implementações pipeline. Esta abordagem é mais eficiente em termos de área de hardware, embora seja mais lenta que implementações pipeline.

## 🏗️ Arquitetura

O processador implementa os seguintes componentes principais:

### Componentes do Datapath
- **PC (Program Counter)**: Contador de programa implementado em `reg32.vhd`
- **Memória de Instrução**: ROM implementada em `rom.vhd`
- **Memória de Dados**: RAM implementada em `ram.vhd`
- **Banco de Registradores**: Implementado em `registers.vhd`
- **ALU (Arithmetic Logic Unit)**: Unidade lógica e aritmética em `alu.vhd`
- **Multiplexadores**: Vários muxes para controle de fluxo de dados (`mux215.vhd`, `mux232.vhd`, `mux332.vhd`, `mux432.vhd`)

### Componentes de Controle
- **Unidade de Controle**: Máquina de estados finita implementada em `control.vhd`
- **Controle da ALU**: Geração de sinais de controle para ALU em `alucontrol.vhd`
- **Registrador de Instrução**: Buffer para instrução atual em `ireg.vhd`

## 🔧 Estrutura dos Arquivos

```
├── design.vhd          # Módulo principal que conecta todos os componentes
├── control.vhd         # Unidade de controle (FSM)
├── alu.vhd            # Unidade Lógica e Aritmética
├── alucontrol.vhd     # Controle da ALU
├── registers.vhd      # Banco de registradores
├── rom.vhd            # Memória de instrução (ROM)
├── ram.vhd            # Memória de dados (RAM)
├── reg32.vhd          # Registrador de 32 bits
├── ff32.vhd           # Flip-flops de 32 bits
├── ireg.vhd           # Registrador de instrução
├── mux*.vhd           # Multiplexadores diversos
├── testbench.vhd      # Testbench para simulação
├── run.sh             # Script de execução
└── work/              # Diretório de compilação
```

## 🎯 Instruções Suportadas

O processador implementa um subconjunto das instruções MIPS, incluindo:

- **Instruções Tipo R**: Operações aritméticas e lógicas entre registradores
- **Instruções Tipo I**: Operações imediatas, loads, stores e branches
- **Instruções Tipo J**: Jumps (saltos incondicionais)

### Ciclos de Execução

O processador utiliza uma máquina de estados finita (FSM) que implementa diferentes números de ciclos para diferentes tipos de instruções:

1. **Fetch**: Busca da instrução na memória
2. **Decode**: Decodificação da instrução e leitura de registradores
3. **Execute**: Execução da operação específica da instrução
4. **Memory**: Acesso à memória (para loads/stores)
5. **Write-back**: Escrita do resultado de volta ao registrador

## 🚀 Como Executar

### Pré-requisitos
- Simulador VHDL (como GHDL, ModelSim, ou Vivado)
- Ambiente de desenvolvimento VHDL configurado

### Execução
```bash
# Tornar o script executável
chmod +x run.sh

# Executar a simulação
./run.sh
```

### Simulação
O arquivo `testbench.vhd` contém o testbench principal que:
- Aplica um clock de 10ns de período
- Controla o reset do processador
- Monitora a execução até que uma condição de parada seja atingida

## 📊 Características Técnicas

- **Largura de dados**: 32 bits
- **Arquitetura**: MIPS multiciclo
- **Linguagem**: VHDL
- **Tipo de implementação**: Comportamental e estrutural
- **Memória**: Separada para instruções (ROM) e dados (RAM)

## 🔍 Observações de Design

- A implementação utiliza uma abordagem multiciclo para otimizar o uso de hardware
- A unidade de controle é implementada como uma máquina de estados finita
- Múltiplos multiplexadores permitem o reuso eficiente das unidades funcionais
- O design separa claramente o datapath da unidade de controle

## 📝 Desenvolvimento

Este projeto foi desenvolvido como uma implementação educacional da arquitetura MIPS, focando na compreensão dos conceitos fundamentais de:
- Arquitetura de computadores
- Design de processadores
- Linguagem de descrição de hardware (VHDL)
- Máquinas de estado finitas
- Organização de sistema computacional

---

**Nota**: Este é um projeto educacional e pode não implementar todas as funcionalidades de um processador MIPS completo.
