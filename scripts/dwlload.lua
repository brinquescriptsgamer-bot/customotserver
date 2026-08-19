-- =============================================================================
-- [BRINQUE SCRIPTS] ARQUIVO 1: SEGURANCA E CONTROLE DE SERVIDORES - PARTE 1 DE 4
-- =============================================================================
setDefaultTab("GUILD")

local panelName = "painelBrinqueMultiServidores"
if type(storage[panelName]) ~= "table" then
    storage[panelName] = {
        servidorFixoAtivo = false,
        servidorSelecionado = "Ilusion"
    }
end
local config = storage[panelName]

-- 🌐 DIRETÓRIOS E LINKS DE ATENDIMENTO ORIGINAIS
local LINK_RENOVACAO  = "https://wa.me"
local LINK_INSTAGRAM  = "https://instagram.com"
local LINK_WHATSAPP   = "https://whatsapp.com"
local LINK_DISCORD    = "https://discord.gg"
local LINK_YOUTUBE    = "https://youtube.com"
local pastaImg        = "/bot/BRINQUE/imagens/"

-- 🌐 URL DO SEU BANCO DE DADOS DE CLIENTES EM NUVEM (RAW GITHUB)
local URL_BANCO_DADOS_NUVEM = "https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/bankdadps.lua"

-- 🧠 CÁLCULO DO HWID LOCAL INDIVIDUAL POR PASTA DO SERVIDOR CONECTADO
local pastaEscritaParaValidar = tostring(g_resources.getWriteDir()):lower():trim()
local hashCalculadoLocal = 0
for i = 1, #pastaEscritaParaValidar do
    hashCalculadoLocal = (hashCalculadoLocal * 31 + string.byte(pastaEscritaParaValidar, i)) % 100000000
end

-- Chave única de hardware compartilhada na memória RAM para este OTServer ativo
hwidDaMaquinaDoCliente = "CELESTIAL-HWID-" .. tostring(hashCalculadoLocal)

-- Inicializadores estáveis aguardando o download da nuvem na Parte 3 e 4
BANCO_DADOS_CLIENTES = {}
computadorEstaAutorizado = false
nomeDoClienteIdentificado = "Nao Afiliado"
dataVencimentoCliente = "Expirado"
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 2 DE 4] STRINGS OTUI DA INTERFACE PRINCIPAL
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()

-- INTERFACE CENTRAL SUPREMA (ANCHOR LAYOUT RETRO COMPATÍVEL)
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaEscolhaMacros\n" ..
"  size: 560 220\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoCustomCelestiais\n" ..
"    image-source: /bot/BRINQUE/imagens/minimalistum.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000055\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblServidoresTitulo\n" ..
"    text: -- SELECIONE O SEU SERVIDOR --\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #00bfff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 20\n" ..
"    margin-left: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  ComboBox\n" ..
"    id: comboServidores\n" ..
"    anchors.top: lblServidoresTitulo.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    margin-left: 25\n" ..
"    margin-right: 25\n" ..
"    height: 22\n" ..
"\n" ..
"  CheckBox\n" ..
"    id: chkSalvarFixo\n" ..
"    text: Entrar automaticamente neste servidor\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #44ff44\n" ..
"    anchors.top: comboServidores.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 12\n" ..
"    margin-left: 25\n" ..
"    height: 16\n" ..
"\n" ..
"  Label\n" ..
"    id: lblRedesTitulo\n" ..
"    text: -- BRINQUE SCRIPTS --\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #FFD700\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 20\n" ..
"    margin-left: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoInsta\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblRedesTitulo.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 24\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnInstagram\n" ..
"    text: Acessar Instagram\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: 4\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoInsta\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoWhats\n" ..
"    image-source: /bot/BRINQUE/imagens/BOTAO.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoInsta.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 10\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 24\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnWhatsApp\n" ..
"    text: Grupo do WhatsApp\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: 4\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoWhats\n" ..
"\n" ..
"  HorizontalSeparator\n" ..
"    id: sepInf\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: closeBtn.top\n" ..
"    margin-bottom: 8\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 60 20\n" ..
"    margin-bottom: 5\n" ..
"    margin-right: 15\n" ..
"    @onClick: self:getParent():hide()\n"

if widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros") then 
    widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros"):destroy() 
end

local setupMacrosWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
setupMacrosWindow:hide()

local function abrirLinkNoNavegadorReal(urlDestino)
    if g_signals and g_signals.openUrl then g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(urlDestino)
    else print(">>> [BRINQUE] Link: " .. urlDestino) end
end

setupMacrosWindow.btnInstagram.onClick = function() abrirLinkNoNavegadorReal(LINK_INSTAGRAM) end
setupMacrosWindow.btnWhatsApp.onClick  = function() abrirLinkNoNavegadorReal(LINK_WHATSAPP) end

-- FILTRO CONTRA CAIXAS INVISÍVEIS POR FALTA DE IMAGEM FÍSICA
local mapeamentoBotoesImagens = {
    { widget = setupMacrosWindow.imgFundoInsta,   file = "BOTAO.png" },
    { widget = setupMacrosWindow.imgFundoWhats,   file = "BOTAO.png" }
}

for _, itemBtn in ipairs(mapeamentoBotoesImagens) do
    if not g_resources.fileExists(pastaImg .. itemBtn.file) then
        itemBtn.widget:setImageSource("")
        itemBtn.widget:setBackgroundColor("#2f2f2f")
    end
end
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 3 DE 4] CONEXÕES GRÁFICAS E MECANISMO DE RELOAD
-- =============================================================================

-- Lista oficial estática dos OTs suportados pela sua rede Brinque Scripts
local LISTA_COMPLETA_SERVIDORES_OTS = { "Ilusion", "Minimalist", "Legedy" }

-- Alimenta a caixa do ComboBox com as opções cadastradas
setupMacrosWindow.comboServidores:clear()
for _, nomeOT in ipairs(LISTA_COMPLETA_SERVIDORES_OTS) do
    setupMacrosWindow.comboServidores:addOption(nomeOT)
end

-- Sincroniza o texto visual do ComboBox baseado na escolha salva na memória
if config.servidorSelecionado ~= "" then
    setupMacrosWindow.comboServidores:setOption(config.servidorSelecionado)
else
    setupMacrosWindow.comboServidores:setOption("Ilusion")
    config.servidorSelecionado = "Ilusion"
end

-- Sincroniza o estado do marcador de entrada automatizada direta
setupMacrosWindow.chkSalvarFixo:setChecked(config.servidorFixoAtivo == true)

-- GATILHO PvP MESTRE: Executado no instante em que o cliente clica e altera o OT
setupMacrosWindow.comboServidores.onOptionChange = function(comboWidget, opcaoTexto, dadosOpcao)
    if config.servidorSelecionado == opcaoTexto then return end
    
    print("[Brinque Scripts] Alteracao de servidor selecionada: " .. opcaoTexto)
    config.servidorSelecionado = opcaoTexto
    
    -- Reseta a entrada automática para obrigar o script a checar a segurança no próximo login
    config.servidorFixoAtivo = false
    setupMacrosWindow.chkSalvarFixo:setChecked(false)
    
    -- Limpa a RAM instantaneamente aplicando o reload forçado
    schedule(100, function() 
        print("[Seguranca] Aplicando recarregamento estrutural do bot...")
        reload() 
    end)
end

-- Clique do marcador de automatização de entrada direta
setupMacrosWindow.chkSalvarFixo.onClick = function(widgetComponente)
    local novoEstadoMarcado = not widgetComponente:isChecked()
    widgetComponente:setChecked(novoEstadoMarcado)
    config.servidorFixoAtivo = novoEstadoMarcado
    print("[Brinque] Entrada automatica para este OT alterada para: " .. tostring(novoEstadoMarcado))
end

-- CONSTRUTOR DO BOTÃO MESTRE NA ABA LATERAL "GUILD"
local uiTravaAba = nil
local function renderizarBotaoMenuLateral(maquinaValida)
    if uiTravaAba then uiTravaAba:destroy() end
    if maquinaValida then
        uiTravaAba = setupUI([[
Panel
  height: 20
  Button
    id: btnMacrosMenu
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 17
    text: Painel Brinque Scripts
    font: verdana-11px-rounded
  ]], getTab("GUILD"))

        uiTravaAba.btnMacrosMenu.onClick = function()
            if setupMacrosWindow:isVisible() then 
                setupMacrosWindow:hide() 
            else 
                setupMacrosWindow:show() 
                setupMacrosWindow:raise() 
                setupMacrosWindow:focus() 
            end
        end
    else
        uiTravaAba = setupUI([[
Panel
  height: 20
  Label
    id: lblAvisoBloqueio
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: PC NAO AUTORIZADO
    font: verdana-11px-rounded
    color: #ff4444
  ]], getTab("GUILD"))
        setupMacrosWindow:hide()
    end
end
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 4 DE 4] WEBHOOK DISCORD, NUVEM E MOTOR DE ARRANCADA
-- =============================================================================

-- Webhook de auditoria comercial Brinque Scripts
local URL_WEBHOOK_DISCORD = "https://discord.com/api/webhooks/1536100384785834064/31bfP1tvqS7nx_s99Vzr6NxAFvGcAf2MGdpPbezQ1hocXHc_DgiGaTDxkTpMyC_lU1NL"
local jaEnviouNotificacao = false

local function registrarNotificacaoNoDiscord(nickChar, idCapturado, statusLicenca, canalTipo)
    if jaEnviouNotificacao then return end
    if not URL_WEBHOOK_DISCORD or URL_WEBHOOK_DISCORD == "" then return end
    
    jaEnviouNotificacao = true
    
    local corEmbed = 65280 -- Verde para Afiliados
    if canalTipo == "Nao Afiliado" then
        corEmbed = 16711680 -- Vermelho para Bloqueados
    end

    local estruturaPayload = {
        username = "Brinque Scripts Alerta",
        embeds = {
            {
                title = "🔒 Sistema de Auditoria - " .. canalTipo,
                color = corEmbed,
                fields = {
                    { name = "👤 Personagem (Nick):", value = nickChar, inline = true },
                    { name = "🖥️ Codigo Gerado (HWID):", value = "`" .. idCapturado .. "`", inline = true },
                    { name = "⚙️ Status / Servidor Selecionado:", value = statusLicenca, inline = true }
                },
                footer = { text = "Controle de Vendas Automatizado - Brinque Scripts" }
            }
        }
    }
    HTTP.postJSON(URL_WEBHOOK_DISCORD, estruturaPayload, function(res, err) end)
end

-- MONITOR DE SEGURANÇA CÍCLICO (A CADA 10 MINUTOS)
macro(600000, function() 
    renderizarBotaoMenuLateral(computadorEstaAutorizado)
    if not computadorEstaAutorizado then reload() end 
end)

-- AUXILIAR DE TEXTO DO EXIVA NATIVO
onTextMessage(function(m, t)
    if m ~= 20 then return end
    local d = t:match("is to the ([a-z-]+)%.") or t:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)

-- =============================================================================
-- GATILHO DE ARRANCADA MESTRE (DOWNLOAD DO BANCO E PARTO DO PROCESSO)
-- =============================================================================
HTTP.get(URL_BANCO_DADOS_NUVEM .. "?v=" .. os.time(), function(txtConteudo, erroNet)
    if erroNet or not txtConteudo then
        print("[Erro Nuvem] Nao foi possivel baixar o Banco de Dados. Acesso trancado.")
        renderizarBotaoMenuLateral(false)
        return
    end

    -- Compila a tabela de clientes da nuvem direto na memoria RAM
    local funcaoCompilada, syntaxErr = loadstring(txtConteudo)
    if funcaoCompilada then 
        pcall(funcaoCompilada) 
    else 
        print("[Erro Sintaxe] Banco de dados corrompido: " .. tostring(syntaxErr))
        renderizarBotaoMenuLateral(false)
        return
    end

    -- Executa a varredura contra a tabela baixada na RAM
    if BANCO_DADOS_CLIENTES then
        for nomeCliente, dados in pairs(BANCO_DADOS_CLIENTES) do
            if dados.servidores and dados.servidores[hwidDaMaquinaDoCliente] then
                nomeDoClienteIdentificado = nomeCliente
                dataVencimentoCliente = dados.vence
                
                if dados.vence == "ilimitado" then
                    computadorEstaAutorizado = true
                else
                    local timestampVencimento = converterDataParaTimestamp(dados.vence)
                    if timestampVencimento and (timestampVencimento - os.time() > 0) then
                        computadorEstaAutorizado = true
                    end
                end
                break
            end
        end
    end

    -- GATILHO DE TIMEOUT SEGURO DE EXIBIÇÃO (1.2 SEGUNDOS DEPOIS DO DOWN)
    schedule(1200, function()
        renderizarBotaoMenuLateral(computadorEstaAutorizado)
        
        local localPlayer = g_game.getLocalPlayer()
        local nickDoCara = localPlayer and localPlayer:getName() or "Desconhecido"
        
        if computadorEstaAutorizado then
            -- LOG DE AFILIADOS / CLIENTES ATIVOS
            registrarNotificacaoNoDiscord(nickDoCara, hwidDaMaquinaDoCliente, "Entrou no Servidor: " .. config.servidorSelecionado, "Afiliado / Cliente")
            
            if config.servidorFixoAtivo then
                print("[Brinque] Entrada automatica ativada para o OT: " .. config.servidorSelecionado)
            else
                if setupMacrosWindow then setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
            end
            
            -- >>> INSTALE A RAW QUE INJETA O ARQUIVO 2 (CARREGADOR DE MACROS DO GITHUB) AQUI DENTRO
            local URL_ARQUIVODOSMACROS = "https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/test/Dwlld.lua"
            HTTP.get(URL_ARQUIVODOSMACROS .. "?v=" .. os.time(), function(macrosCont, errM)
                if not errM then
                    local injetorMacros, sErr = loadstring(macrosCont)
                    if injetorMacros then pcall(injetorMacros) else print("[Erro Nuvem] Falha no Carregador: " .. tostring(sErr)) end
                end
            end)
        else
            -- LOG DE NÃO AFILIADOS / REJEITADOS
            registrarNotificacaoNoDiscord(nickDoCara, hwidDaMaquinaDoCliente, "Rejeitado na tela de Selecao", "Nao Afiliado")
            
            if setupMacrosWindow then setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
            print("=========================================================================")
            print(">>> [BRINQUE SCRIPTS] ACESSO BLOQUEADO! PC nao registrado neste OT.")
            print(">>> Envie este ID para o Admin liberar o plano: " .. hwidDaMaquinaDoCliente)
            print("=========================================================================")
        end
    end)
end)
