-- =============================================================================
-- [BRINQUE SCRIPTS] ARQUIVO 1: SEGURANCA E CONTROLE DE SERVIDORES - PARTE 1 DE 4
-- =============================================================================
setDefaultTab("main")

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
-- [PAINEL CENTRAL - PARTE 2 DE 4] STRINGS OTUI COM STATUS COMPLETO E ID DO PC
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()

-- INTERFACE CENTRAL SUPREMA (ANCHOR LAYOUT RETRO COMPATIVEL)
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaEscolhaMacros\n" ..
"  size: 560 300\n" ..
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
"  Button\n" ..
"    id: btnConfirmarEntrada\n" ..
"    text: ABRIR SCRIPTS DO OT\n" ..
"    color: #44ff44\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: chkSalvarFixo.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 15\n" ..
"    margin-left: 25\n" ..
"    margin-right: 25\n" ..
"    height: 24\n" ..
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
"  Label\n" ..
"    id: lblLicencaInfo\n" ..
"    text: Licenca: Carregando dados...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #44ff44\n" ..
"    anchors.top: btnConfirmarEntrada.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 12\n" ..
"    text-align: center\n" ..
"\n" ..
"  Label\n" ..
"    id: lblIDInfo\n" ..
"    text: ID DO PC ATUAL: ...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #FFD700\n" ..
"    anchors.top: lblLicencaInfo.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.horizontalCenter\n" ..
"    margin-top: 6\n" ..
"    text-align: center\n" ..
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

-- Injeta o texto do ID gerado por pasta na label dourada de status
if setupMacrosWindow and setupMacrosWindow.lblIDInfo then
    setupMacrosWindow.lblIDInfo:setText("ID DO PC ATUAL: " .. tostring(hwidDaMaquinaDoCliente))
end

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
-- [PAINEL CENTRAL - PARTE 3 DE 4] GANCHOS VISUAIS E MENUS LATERAIS PERMANENTES
-- =============================================================================

local LISTA_COMPLETA_SERVIDORES_OTS = { "Ilusion", "Minimalist", "Legedy" }

-- Alimenta o ComboBox com os nomes mapeados na nuvem
setupMacrosWindow.comboServidores:clear()
for _, nomeOT in ipairs(LISTA_COMPLETA_SERVIDORES_OTS) do
    setupMacrosWindow.comboServidores:addOption(nomeOT)
end

-- Sincroniza o texto visual do ComboBox baseado na memoria de configuracao
if config.servidorSelecionado ~= "" then
    setupMacrosWindow.comboServidores:setOption(config.servidorSelecionado)
else
    setupMacrosWindow.comboServidores:setOption("Ilusion")
    config.servidorSelecionado = "Ilusion"
end

-- Sincroniza a caixinha do bypass de entrada automatica direta
setupMacrosWindow.chkSalvarFixo:setChecked(config.servidorFixoAtivo == true)

-- MUDANÇA DE OPÇÃO SUAVE: Apenas grava a intencao do cliente sem forcar travamentos
setupMacrosWindow.comboServidores.onOptionChange = function(comboWidget, opcaoTexto, dadosOpcao)
    if config.servidorSelecionado == opcaoTexto then return end
    
    print("=========================================================================")
    print("[Brinque Scripts] Voce alterou a selecao para o OT: " .. opcaoTexto)
    print("[AVISO] Para aplicar as alteracoes, clique no botao ABRIR SCRIPTS DO OT!")
    print("=========================================================================")
    
    config.servidorSelecionado = opcaoTexto
    
    -- Reseta a entrada automatica para obrigar o cruzamento de ID ao confirmar
    config.servidorFixoAtivo = false
    setupMacrosWindow.chkSalvarFixo:setChecked(false)
end

-- Clique do marcador de automatizacao de entrada direta
setupMacrosWindow.chkSalvarFixo.onClick = function(widgetComponente)
    local novoEstadoMarcado = not widgetComponente:isChecked()
    widgetComponente:setChecked(novoEstadoMarcado)
    config.servidorFixoAtivo = novoEstadoMarcado
    print("[Brinque] Entrada automatica para este OT alterada para: " .. tostring(novoEstadoMarcado))
end

-- CONSTRUTOR DO BOTÃO MESTRE FIXO E PERMANENTE NA ABA LATERAL "GUILD"
local uiTravaAba = nil
local function renderizarBotaoMenuLateral(maquinaValida)
    if uiTravaAba then uiTravaAba:destroy() end
    
    -- O botao lateral agora e unico e fixo para qualquer status de seguranca
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
  ]], getTab("main"))

    -- Evento de clique continua abrindo, subindo e focando a janela principal
    uiTravaAba.btnMacrosMenu.onClick = function()
        if setupMacrosWindow:isVisible() then 
            setupMacrosWindow:hide() 
        else 
            setupMacrosWindow:show() 
            setupMacrosWindow:raise() 
            setupMacrosWindow:focus() 
        end
    end
end

-- =============================================================================
-- [PAINEL CENTRAL - PARTE 4A DE 4] AUDITORIA DISCORD E ESTRUTURAS DE FUNDO
-- =============================================================================

-- Webhook de auditoria comercial Brinque Scripts
local URL_WEBHOOK_DISCORD = "https://discord.com"
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

-- MONITOR DE SEGURANÇA CÍCLICO DE BASTIDORES (A CADA 10 MINUTOS)
macro(600000, function() 
    renderizarBotaoMenuLateral(computadorEstaAutorizado)
    if not computadorEstaAutorizado then 
        print("[Seguranca] Sessao expirada ou invalida. Macros recolhidos.")
    end 
end)

-- AUXILIAR DE TEXTO DO EXIVA NATIVO
onTextMessage(function(m, t)
    if m ~= 20 then return end
    local d = t:match("is to the ([a-z-]+)%.") or t:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 4B DE 4] VALIDAÇÃO EM NUVEM E INTERCEPTOR DO WHATSAPP
-- =============================================================================

local function executarProcessamentoDeSegurancaENuvem(modoSilencioso)
    HTTP.get(URL_BANCO_DADOS_NUVEM .. "?nocache=" .. os.time(), function(txtConteudo, erroNet)
        if erroNet or not txtConteudo then
            print("[Erro Nuvem] Falha ao baixar banco de dados. Acesso trancado.")
            if setupMacrosWindow and setupMacrosWindow.lblLicencaInfo then
                setupMacrosWindow.lblLicencaInfo:setText("Licenca: Erro de Conexao com Nuvem")
                setupMacrosWindow.lblLicencaInfo:setColor("#ff4444")
            end
            renderizarBotaoMenuLateral(false)
            return
        end

        local funcaoCompilada, syntaxErr = loadstring(txtConteudo)
        if funcaoCompilada then pcall(funcaoCompilada) else 
            print("[Erro Sintaxe] Tabela corrompida: " .. tostring(syntaxErr))
            renderizarBotaoMenuLateral(false)
            return
        end

        local function converterDataParaTimestampMestre(dataTexto)
            local dia, mes, ano = dataTexto:match("(%d+)/(%d+)/(%d+)")
            if dia and mes and ano then 
                return os.time({year = tonumber(ano), month = tonumber(mes), day = tonumber(dia), hour = 23, min = 59, sec = 59}) 
            end
            return nil
        end

        computadorEstaAutorizado = false
        nomeDoClienteIdentificado = "Nao Afiliado"
        dataVencimentoCliente = "Expirado"

        if BANCO_DADOS_CLIENTES then
            for nomeCliente, dados in pairs(BANCO_DADOS_CLIENTES) do
                if dados.servidores and dados.servidores[hwidDaMaquinaDoCliente] then
                    local nomeDoServidorDesseID = dados.servidores[hwidDaMaquinaDoCliente]
                    
                    if nomeDoServidorDesseID == config.servidorSelecionado then
                        nomeDoClienteIdentificado = nomeCliente
                        dataVencimentoCliente = dados.vence
                        
                        if dados.vence == "ilimitado" then
                            computadorEstaAutorizado = true
                        else
                            local timestampVencimento = converterDataParaTimestampMestre(dados.vence)
                            if timestampVencimento and (timestampVencimento - os.time() > 0) then
                                computadorEstaAutorizado = true
                            end
                        end
                        break
                    end
                end
            end
        end

        if setupMacrosWindow then
            if computadorEstaAutorizado then
                if setupMacrosWindow.btnConfirmarEntrada then
                    setupMacrosWindow.btnConfirmarEntrada:setText("ABRIR SCRIPTS DO OT")
                    setupMacrosWindow.btnConfirmarEntrada:setColor("#44ff44")
                end
                if setupMacrosWindow.lblLicencaInfo then
                    if dataVencimentoCliente == "ilimitado" then
                        setupMacrosWindow.lblLicencaInfo:setText("Cliente: " .. nomeDoClienteIdentificado .. " (Permanente)")
                        setupMacrosWindow.lblLicencaInfo:setColor("#00bfff")
                    else
                        setupMacrosWindow.lblLicencaInfo:setText("Cliente: " .. nomeDoClienteIdentificado .. " (Ate: " .. dataVencimentoCliente .. ")")
                        setupMacrosWindow.lblLicencaInfo:setColor("#44ff44")
                    end
                end
            else
                if setupMacrosWindow.btnConfirmarEntrada then
                    setupMacrosWindow.btnConfirmarEntrada:setText("FALAR COM ADMINISTRADOR (RENOVAR)")
                    setupMacrosWindow.btnConfirmarEntrada:setColor("#ff4444")
                end
                if setupMacrosWindow.lblLicencaInfo then
                    setupMacrosWindow.lblLicencaInfo:setText("Status: PC Nao Autorizado para o OT: " .. config.servidorSelecionado)
                    setupMacrosWindow.lblLicencaInfo:setColor("#ff4444")
                end
            end
        end

        renderizarBotaoMenuLateral(computadorEstaAutorizado)
        local localPlayer = g_game.getLocalPlayer()
        local nickDoCara = localPlayer and localPlayer:getName() or "Desconhecido"

        if computadorEstaAutorizado then
            registrarNotificacaoNoDiscord(nickDoCara, hwidDaMaquinaDoCliente, "Liberado no OT: " .. config.servidorSelecionado, "Afiliado / Cliente")
            print("[Brinque Scripts] Acesso confirmado! Baixando macros do servidor: " .. config.servidorSelecionado)
            
            local URL_ARQUIVODOSMACROS = "https://githubusercontent.com"
            HTTP.get(URL_ARQUIVODOSMACROS .. "?nocache=" .. os.time(), function(macrosCont, errM)
                if not errM then
                    local injetorMacros, sErr = loadstring(macrosCont)
                    if injetorMacros then pcall(injetorMacros) else print("[Erro Nuvem] Falha no Carregador: " .. tostring(sErr)) end
                end
            end)
            
            if not modoSilencioso and setupMacrosWindow then setupMacrosWindow:hide() end
        else
            registrarNotificacaoNoDiscord(nickDoCara, hwidDaMaquinaDoCliente, "Rejeitado para o OT: " .. config.servidorSelecionado, "Nao Afiliado")
            if not modoSilencioso and setupMacrosWindow then setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
            print("=========================================================================")
            print(">>> [BRINQUE SCRIPTS] ACESSO NEGADO! ID de pasta invalido para o OT: " .. config.servidorSelecionado)
            print(">>> Cadastre este ID de pasta no Admin: " .. hwidDaMaquinaDoCliente)
            print("=========================================================================")
        end
    end)
end

-- SEPARAÇÃO CIRÚRGICA DOS LINKS: O clique testa o status real atualizado antes de agir
setupMacrosWindow.btnConfirmarEntrada.onClick = function()
    if computadorEstaAutorizado then
        -- ESTADO ATIVO: Roda o injetor em nuvem e abre os macros normalmente
        jaEnviouNotificacao = false 
        print("[Brinque] Processando checagem cruzada de credenciais em nuvem...")
        executarProcessamentoDeSegurancaENuvem(false)
    else
        -- ESTADO BLOQUEADO: Desvia o clique e joga o cliente estritamente para o suporte do WhatsApp
        print("[Brinque Support] Redirecionando cliente bloqueado para o suporte no WhatsApp...")
        abrirLinkNoNavegadorReal(LINK_RENOVACAO)
    end
end

schedule(1200, function()
    if config.servidorFixoAtivo then
        executarProcessamentoDeSegurancaENuvem(true)
    else
        executarProcessamentoDeSegurancaENuvem(true)
        if setupMacrosWindow then setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
    end
end)
