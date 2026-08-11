setDefaultTab("GUILD")

local panelName = "painelBrinqueScripts"
if type(storage[panelName]) ~= "table" then
    storage[panelName] = {
        height = 140,
        macrosMarcados = {
            antipush = true, configs = true, potguild = true, filtro = true,
            rainbow = true, skills = true, bola = true, combo = true,
            energyssa = true, stamina = true, healing = true, exiva = true,
            magias = true, fps = true, abrirbag = true
        }
    }
end

local config = storage[panelName]

-- =============================================================================
-- [BLOCO 1] BANCO DE DADOS E CONFIGURAÇÕES - BRINQUE SCRIPTS
-- =============================================================================
local LINK_RENOVACAO = "https://wa.me/qr/QHQWPAJNPYRDJ1" -- Seu link de atendimento

-- CADASTRO DE CLIENTES (Você vai preenchendo com os códigos que chegarem no seu Discord)
local BANCO_DADOS_CLIENTES = {
    -- Seu computador permanente (Troque pelo seu ID definitivo que chegar no Discord)
    ["CELESTIAL-HWID-37646993"] = {
        nome = "Dono Brinque Scripts",
        compra = "01/08/2026",
        vence = "ilimitado"
    },
    ["CELESTIAL-HWID-11111111"] = {
        nome = "Patrocinador Oficial",
        compra = "01/08/2026",
        vence = "ilimitado"
    }
}

-- LINKS DAS SUAS REDES SOCIAIS DO PAINEL PRINCIPAL
local LINK_INSTAGRAM = "https://www.instagram.com/brinquescriptsgamer?igsh=dXhhN2MxNWhxMm9m"
local LINK_WHATSAPP  = "https://chat.whatsapp.com/D4WHVuAy41t6uQ6QZ3ibtR"
local LINK_DISCORD   = "https://discord.gg/BRNzJ7cZjq"
local LINK_YOUTUBE   = "https://youtube.com"

local script_path = "/scripts_storage/"
-- =============================================================================
-- [BLOCO 2 - METADE A] ESTRUTURA OTUI DE LICENÇA E BLOQUEIO VISUAL
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()

-- JANELA A: AVISO DE LICENÇA (PARA CLIENTES ATIVOS COM DIAS)
local designAvisoLicencaOTUI = "MainWindow\n" ..
"  id: janelaAvisoLicenca\n" ..
"  !text: tr('Painel de Acesso - Brinque Scripts')\n" ..
"  size: 320 200\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoAviso\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/M_custompremium.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #000000B0\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblNomeCliente\n" ..
"    text: Cliente: Carregando...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 15\n" ..
"    margin-left: 20\n" ..
"\n" ..
"  Label\n" ..
"    id: lblDiasRestantes\n" ..
"    text: Status do Acesso: Calculando...\n" ..
"    font: verdana-11px-rounded\n" ..
"    anchors.top: lblNomeCliente.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    margin-top: 12\n" ..
"    margin-left: 20\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoBtnRenovar\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblDiasRestantes.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -50\n" ..
"    margin-left: 30\n" ..
"    margin-right: 30\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnRenovar\n" ..
"    text: Renovar / Prolongar Dias\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: 4\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoBtnRenovar\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtn\n" ..
"    text: Fechar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-left: 20\n" ..
"    margin-right: 20\n" ..
"    margin-bottom: 8\n" ..
"    height: 18\n"

-- JANELA B: TELA DE BLOQUEIO PARA QUANDO O MODO LIVRE FOR DESLIGADO NO FUTURO
local designBloqueioHWIDOTUI = "MainWindow\n" ..
"  id: janelaBloqueioHWID\n" ..
"  !text: tr('Acesso Negado - Brinque Scripts')\n" ..
"  size: 340 230\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoBloqueio\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/M_custompremium.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #000000C0\n" ..
"    anchors.fill: parent\n" ..
"    phantom: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblMsgBloqueio\n" ..
"    text: Seu computador nao esta registrado!\\nEnvie o codigo abaixo para o Administrador.\\nPara liberar o seu acesso de forma imediata.\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ff4444\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    margin-left: 10\n" ..
"    margin-right: 10\n" ..
"    height: 50\n" ..
"\n" ..
"  Label\n" ..
"    id: lblCodigoPC\n" ..
"    text: ID DO PC: ...\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #FFD700\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    anchors.top: lblMsgBloqueio.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 15\n" ..
"    height: 16\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoBtnSuporte\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblCodigoPC.bottom\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 20\n" ..
"    margin-left: 40\n" ..
"    margin-right: 40\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnFalarAdmin\n" ..
"    text: Enviar ID para o Suporte\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: 4\n" ..
"    phantom: false\n" ..
"    anchors.fill: imgFundoBtnSuporte\n"
-- JANELA C: PAINEL PRINCIPAL DE MACROS ORIGINAL (560x380)
local designPrincipalOTUI = "MainWindow\n" ..
"  id: janelaEscolhaMacros\n" ..
"  size: 560 380\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoCustomCelestiais\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/M_custompremium.png\n" ..
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
"  ScrollablePanel\n" ..
"    id: listaScroll\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: barraRolagem.left\n" ..
"    anchors.bottom: sepInf.top\n" ..
"    margin-top: 10\n" ..
"    margin-left: 10\n" ..
"    margin-right: 2\n" ..
"    margin-bottom: 5\n" ..
"    vertical-scrollbar: barraRolagem\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: barraRolagem\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.bottom: sepInf.top\n" ..
"    anchors.right: lblRedesTitulo.left\n" ..
"    margin-top: 10\n" ..
"    margin-bottom: 5\n" ..
"    margin-right: 5\n" ..
"    step: 20\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  Label\n" ..
"    id: lblRedesTitulo\n" ..
"    text: -- REDES SOCIAIS DA GUILDA --\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #00bfff\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 20\n" ..
"    margin-left: 15\n" ..
"    text-align: center\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoInsta\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: lblRedesTitulo.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -65\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnInstagram\n" ..
"    text: Acessar Instagram\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -5\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoInsta\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoWhats\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoInsta.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -165\n" ..
"    margin-left: 30\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnWhatsApp\n" ..
"    text: Grupo do WhatsApp\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -5\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoWhats\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoDiscord\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoWhats.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -165\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnDiscord\n" ..
"    text: Servidor do Discord\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -5\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoDiscord\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoYoutube\n" ..
"    image-source: /bot/CUSTOM_PREMIUM/imagens/butaoazulverme.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.top: imgFundoDiscord.bottom\n" ..
"    anchors.left: parent.horizontalCenter\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: -165\n" ..
"    margin-left: 20\n" ..
"    margin-right: 15\n" ..
"    height: 200\n" ..
"    phantom: true\n" ..
"  Label\n" ..
"    id: btnYouTube\n" ..
"    text: Canal do YouTube\n" ..
"    font: verdana-11px-rounded\n" ..
"    color: #ffffff\n" ..
"    text-auto-resize: false\n" ..
"    text-align: center\n" ..
"    margin-top: -5\n" ..
"    phantom: false\n" ..
"    anchors.centerIn: imgFundoYoutube\n" ..
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

if widgetRaizDoJogo:recursiveGetChildById("janelaAvisoLicenca") then widgetRaizDoJogo:recursiveGetChildById("janelaAvisoLicenca"):destroy() end
if widgetRaizDoJogo:recursiveGetChildById("janelaBloqueioHWID") then widgetRaizDoJogo:recursiveGetChildById("janelaBloqueioHWID"):destroy() end
if widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros") then widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros"):destroy() end

local setupAvisoWindow    = setupUI(designAvisoLicencaOTUI, widgetRaizDoJogo)
local setupBloqueioWindow = setupUI(designBloqueioHWIDOTUI, widgetRaizDoJogo)
local setupMacrosWindow   = setupUI(designPrincipalOTUI, widgetRaizDoJogo)

setupAvisoWindow:hide()
setupBloqueioWindow:hide()
setupMacrosWindow:hide()

local pastaImg = "/bot/CUSTOM_PREMIUM/imagens/"
if not g_resources.fileExists(pastaImg .. "butaoazulverme.png") then
    setupMacrosWindow.imgFundoInsta:setImageSource("")
    setupMacrosWindow.imgFundoWhats:setImageSource("")
    setupMacrosWindow.imgFundoDiscord:setImageSource("")
    setupMacrosWindow.imgFundoYoutube:setImageSource("")
    setupAvisoWindow.imgFundoBtnRenovar:setImageSource("")
    setupBloqueioWindow.imgFundoBtnSuporte:setImageSource("")
end
-- =============================================================================
-- [BLOCO 3 - METADE A] CONEXÕES DE REDE E INTEGRADOR DE RASTREAMENTO DISCORD
-- =============================================================================
local function abrirLinkNoNavegadorReal(urlDestino)
    if g_signals and g_signals.openUrl then g_signals.openUrl(urlDestino)
    elseif g_platform and g_platform.openUrl then g_platform.openUrl(urlDestino)
    else print(">>> [BRINQUE] Link para copiar: " .. urlDestino) end
end

setupMacrosWindow.btnInstagram.onClick = function() abrirLinkNoNavegadorReal(LINK_INSTAGRAM) end
setupMacrosWindow.btnWhatsApp.onClick  = function() abrirLinkNoNavegadorReal(LINK_WHATSAPP) end
setupMacrosWindow.btnDiscord.onClick   = function() abrirLinkNoNavegadorReal(LINK_DISCORD) end
setupMacrosWindow.btnYouTube.onClick   = function() abrirLinkNoNavegadorReal(LINK_YOUTUBE) end

setupAvisoWindow.btnRenovar.onClick = function() abrirLinkNoNavegadorReal(LINK_RENOVACAO) end
setupAvisoWindow.closeBtn.onClick   = function() setupAvisoWindow:hide() end
setupBloqueioWindow.btnFalarAdmin.onClick = function() abrirLinkNoNavegadorReal(LINK_RENOVACAO) end

local uiTravaAba = nil
local function renderizarBotaoMenuLateral(maquinaValida, mensagemStatus, corStatus)
    if uiTravaAba then uiTravaAba:destroy() end
    if maquinaValida then
        uiTravaAba = setupUI([[
Panel
  height: 40
  Button
    id: btnChecar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.horizontalCenter
    margin-right: 2
    height: 17
    text: Ver Licenca
    font: verdana-11px-rounded
  Button
    id: btnMacrosMenu
    anchors.top: parent.top
    anchors.left: parent.horizontalCenter
    anchors.right: parent.right
    margin-left: 2
    height: 17
    text: Escolher Macros
    font: verdana-11px-rounded
  ]], getTab("GUILD"))

        uiTravaAba.btnChecar.onClick = function()
            if setupAvisoWindow:isVisible() then setupAvisoWindow:hide() else setupAvisoWindow:show() setupAvisoWindow:raise() setupAvisoWindow:focus() end
        end
        uiTravaAba.btnMacrosMenu.onClick = function()
            if setupMacrosWindow:isVisible() then setupMacrosWindow:hide() else setupMacrosWindow:show() setupMacrosWindow:raise() setupMacrosWindow:focus() end
        end
    else
        uiTravaAba = setupUI(string.format([[
Panel
  height: 20
  Label
    id: lblAvisoBloqueio
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: %%s
    font: verdana-11px-rounded
    color: %%s
  ]], mensagemStatus, corStatus), getTab("GUILD"))
        setupMacrosWindow:hide()
    end
end

-- 💥 WEBHOOK DO SEU DISCORD: Crie um webhook no seu canal secreto e cole o link completo aqui!
local URL_WEBHOOK_DISCORD = "https://discord.com/api/webhooks/1536100384785834064/31bfP1tvqS7nx_s99Vzr6NxAFvGcAf2MGdpPbezQ1hocXHc_DgiGaTDxkTpMyC_lU1NL"

-- Função oculta que monta e despacha a ficha do jogador direto pro seu celular
local function registrarNovoUsuarioNoDiscord(nickChar, idCapturado, statusLicenca)
    if not URL_WEBHOOK_DISCORD or URL_WEBHOOK_DISCORD == "" or URL_WEBHOOK_DISCORD:find("COLE_AQUI") then return end
    
    local estruturaPayload = {
        username = "Brinque Scripts Rastreador",
        embeds = {
            {
                title = "📡 Novo Usuário Conectado - Modo Livre Ativo",
                color = 65280, -- Cor verde de sucesso no Discord indicando entrada liberada
                fields = {
                    { name = "👤 Personagem (Nick):", value = nickChar, inline = true },
                    { name = "🖥️ Código da Máquina (HWID):", value = "`" .. idCapturado .. "`", inline = true },
                    { name = "⚙️ Status Atual no Código:", value = statusLicenca, inline = true }
                },
                footer = { text = "Banco de Dados Silencioso - Brinque Scripts" }
            }
        }
    }
    
    HTTP.postJSON(URL_WEBHOOK_DISCORD, estruturaPayload, function(res, err) end)
end
-- =============================================================================
-- [BLOCO 3 - METADE B] INTERRUPTOR DE MODO LIVRE E MAPA DE MACROS
-- =============================================================================
local MAPA_MACROS_GUILDA = {
    -- ==========================================
    -- MACROS COM PRIORIDADE (HEALING)
    -- ==========================================
    { nome = "HEALING BRQ",          key = "healingBRQ",         cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/healingBRQ.lua" },
    { nome = "OPEN BAG MAIN BRQ",    key = "openbagmainBRQ",     cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/openbagmainBRQ.lua" },
    { nome = "BLESSED HP/MP BRQ",    key = "blessedhpmpBRQ",     cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/blessed_hpmpBRQ.lua" },
    { nome = "ENEGY-SSA-MIGHT BRQ",  key = "energyssamightBRQ",  cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/enegy_ssa_mightBRQ.lua" },
	{ nome = "Painel",    key = "painel",     cat = "EXTRAS",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Painel.lua" },
    { nome = "POT GUILD BRQ",        key = "potguildBRQ",        cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/potguildBRQ.lua" },
    { nome = "BUFF BRQ",             key = "BRQbuff",            cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/BRQ_buff_v1.0.lua" },
	{ nome = "STAMINA BRQ",          key = "staminaBRQ",         cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/staminaBRQ.lua" },


    -- ==========================================
    -- MACROS SEM PRIORIDADE (CAVE/TARGET)
    -- ==========================================
    { nome = "FUGA COMPLETA BRQ",    key = "fugacompletaBRQ",    cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/fugacompletaBRQ.lua" },
    { nome = "OLHEIRO_BRQ",          key = "olheiroBRQ",         cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/olheiro_BRQ1.0.lua" },
    { nome = "COMBO LIDER BRQ",      key = "comboliderBRQ",      cat = "CAVE/TARGET", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/comboliderBRQ.lua" },
    { nome = "OUTFIT VISUAL BRQ",    key = "outfitvisualBRQ",    cat = "CAVE/TARGET", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/outfitvisualBRQ.lua" },
    { nome = "TARGET PLAY OFF",      key = "targetplayoffBRQ",   cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/targetplayoffBRQ.lua" },
    -- ==========================================
    -- MACROS DA AUTOMATICO GUILDA (WAR)
    -- ==========================================
    { nome = "3 PUSHE BRQ",          key = "3pusheBRQ",          cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/3pusheBRQ.lua" },
    { nome = "ANTPUSHE MOUSE-PE BRQ", key = "antpushemousepeBRQ", cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/Dropar_item_na_posicao_do_mouseBRQ.lua" },
    { nome = "MW NO PE",             key = "MWPE",               cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/mwnopeBRQ.lua" },
    { nome = "PUXAR AO REDOR BRQ",   key = "puxaraoredorBRQ",    cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/puxaraoredorBRQ.lua" },
    { nome = "EXIVA BRQ",            key = "exivaBRQ",           cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/exivaBRQ.lua" },

    -- ==========================================
    -- MACROS EXTRAS (EXTRAS)
    -- ==========================================
	{ nome = "FILTRO BATTLE BRQ",    key = "filtrobatleBRQ",     cat = "HEALING",     url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/filtrobatleBRQ" },
	{ nome = "SKILLS BRQ",           key = "skillsBRQ",          cat = "CAVE/TARGET", url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/skillsBRQ.lua" },
    { nome = "FPS BRQ",              key = "fpsBRQ",             cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/fpsBRQ.lua" },
	{ nome = "BUGMAP BRQ",              key = "bugmapBRQ",             cat = "EXTRAS",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/bugmap.lua" },
    { nome = "RAINBOW COLOR BRQ",    key = "rainbowcolorBRQ",    cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/rainbowcolorBRQ.lua" },
    { nome = "HUND COLOR BRQ",       key = "hundcolorBRQ",       cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/hundcolorBRQ.lua" },
    { nome = "OPEN BAG CHEIA BRQ",   key = "openbagcheiaBRQ",    cat = "EXTRAS",       url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/openbagcheiaBRQ.lua" },
	{ nome = "MAGIAS S/PK BRQ",      key = "magiasempkBRQ",      cat = "WAR",         url = "https://raw.githubusercontent.com/Brinquee/GUILDA_MOST_WANTED/refs/heads/main/scripts/Guilda/magiasempkBRQ.lua" }
}

local function converterDataParaTimestamp(dataTexto)
    local dia, mes, ano = dataTexto:match("(%d+)/(%d+)/(%d+)")
    if dia and mes and ano then return os.time({year = tonumber(ano), month = tonumber(mes), day = tonumber(dia), hour = 23, min = 59, sec = 59}) end
    return nil
end

-- ENGENHARIA SUPREMA: Isola a pasta Roaming do Windows (Que contém o nome do usuário único do PC)
local writeDirCompleto = tostring(g_resources.getWriteDir()):lower():trim()
local caminhoFiltradoUsuario = writeDirCompleto:match("(.-/otclientv8/)") or writeDirCompleto:match("(.-/visualbot/)") or writeDirCompleto

-- Loop matemático baseado estritamente na identidade única do Windows do cara
local hashCalculadoLocal = 0
for i = 1, #caminhoFiltradoUsuario do 
    hashCalculadoLocal = (hashCalculadoLocal * 31 + string.byte(caminhoFiltradoUsuario, i)) % 100000000 
end
hwidDaMaquinaDoCliente = "BRINQUE-ID-" .. tostring(hashCalculadoLocal)

-- CHAVE MESTRE: Mantida em true para capturar os novos códigos separados no seu Discord
local MODO_LIVRE_RASTREADOR = true

local computadorEstaAutorizado = false
local stringAvisoAba = "PC NAO REGISTRADO"
local corAvisoAba = "#ff4444"

local dadosDestePC = BANCO_DADOS_CLIENTES[hwidDaMaquinaDoCliente]

if dadosDestePC then
    setupAvisoWindow.lblNomeCliente:setText("Cliente: " .. dadosDestePC.nome)
    
    if dadosDestePC.vence == "ilimitado" then
        computadorEstaAutorizado = true
        stringAvisoAba = "ACESSO PERMANENTE"
        corAvisoAba = "#00bfff"
        setupAvisoWindow.lblDiasRestantes:setText("Status do Acesso: Permanente")
        setupAvisoWindow.lblDiasRestantes:setColor("#00bfff")
        print("[BRINQUE SCRIPTS] Administrador verificado! Acesso ilimitado concedido.")
    else
        local timestampVencimento = converterDataParaTimestamp(dadosDestePC.vence)
        if timestampVencimento then
            local segundosRestantes = timestampVencimento - os.time()
            local diasRestantes = math.ceil(segundosRestantes / 86400)
            
            if diasRestantes > 0 then
                computadorEstaAutorizado = true
                stringAvisoAba = "PC AUTORIZADO"
                corAvisoAba = "#44ff44"
                setupAvisoWindow.lblDiasRestantes:setText("Dias Restantes: " .. diasRestantes .. " dias")
                
                if diasRestantes <= 7 then
                    setupAvisoWindow.lblDiasRestantes:setColor("#ff4444")
                    stringAvisoAba = "RENOVAR EM BREVE"
                    corAvisoAba = "#ff4444"
                else
                    setupAvisoWindow.lblDiasRestantes:setColor("#44ff44")
                end
                setupAvisoWindow:show()
            else
                if MODO_LIVRE_RASTREADOR then
                    computadorEstaAutorizado = true
                    stringAvisoAba = "ACESSO LIVRE (TEMP)"
                    corAvisoAba = "#44ff44"
                    local nomeDoBoneco = player and player:getName() or "Desconhecido"
                    registrarNovoUsuarioNoDiscord(nomeDoBoneco, hwidDaMaquinaDoCliente, "Licenca Vencida (Liberado pelo Modo Livre)")
                else
                    stringAvisoAba = "ACESSO EXPIRADO"
                    setupAvisoWindow.lblDiasRestantes:setText("Acesso Expirado! Bloqueado.")
                    setupAvisoWindow.lblDiasRestantes:setColor("#ff4444")
                    setupAvisoWindow.closeBtn:hide()
                    setupAvisoWindow:show()
                    MAPA_MACROS_GUILDA = {}
                end
            end
        end
    end
else
    if MODO_LIVRE_RASTREADOR then
        computadorEstaAutorizado = true
        stringAvisoAba = "ACESSO LIVRE"
        corAvisoAba = "#44ff44"
        print("[BRINQUE SCRIPTS] Modo Livre ativo. Inicializando macros desimpedidos...")
        
        local nomeDoBoneco = player and player:getName() or "Desconhecido"
        registrarNovoUsuarioNoDiscord(nomeDoBoneco, hwidDaMaquinaDoCliente, "Nao Registrado (Capturado no Modo Livre)")
    else
        setupBloqueioWindow.lblCodigoPC:setText("ID DO PC: " .. hwidDaMaquinaDoCliente)
        setupBloqueioWindow:show()
        MAPA_MACROS_GUILDA = {}
    end
end

local ORDEM_CATEGORIAS = { "HEALING", "CAVE/TARGET", "WAR", "EXTRAS" }
local CORES_CATEGORIAS = { ["HEALING"] = "#44ff44", ["CAVE/TARGET"] = "#00bfff", ["WAR"] = "#ff4444", ["EXTRAS"] = "#e6bc22" }

for _, nomeCat in ipairs(ORDEM_CATEGORIAS) do
    local div = g_ui.createWidget("Label", setupMacrosWindow.listaScroll)
    div:setText("-- " .. nomeCat .. " --")
    div:setFont("verdana-11px-rounded")
    div:setColor(CORES_CATEGORIAS[nomeCat])
    div:setMarginTop(5)
    div:setMarginBottom(2)

    for _, item in ipairs(MAPA_MACROS_GUILDA) do
        if item.cat == nomeCat then
            if config.macrosMarcados[item.key] == nil then config.macrosMarcados[item.key] = true end
            local box = g_ui.createWidget("CheckBox", setupMacrosWindow.listaScroll)
            box:setText(item.nome)
            box:setFont("verdana-11px-rounded")
            box:setHeight(16)
            box:setChecked(config.macrosMarcados[item.key] == true)
            box.onClick = function(w)
                local val = not w:isChecked()
                w:setChecked(val)
                config.macrosMarcados[item.key] = val
            end
        end
    end
end

-- =============================================================================
-- [BLOCO 4] EXECUTOR DE FILA HTTP E EVENTOS REMOTOS - BRINQUE SCRIPTS
-- =============================================================================
local loteJaEstaSendoBaixado = false
local function executarFilaCustomizadaHTTP(indice)
    if not computadorEstaAutorizado then return end
    if indice == 1 then if loteJaEstaSendoBaixado then return end loteJaEstaSendoBaixado = true end
    
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then 
        print("[Brinque Scripts] Todos os macros ativos injetados via nuvem com sucesso.")
        loteJaEstaSendoBaixado = false 
        return 
    end
    
    if config.macrosMarcados[macroAlvo.key] == true then
        HTTP.get(macroAlvo.url .. "?v=" .. os.time(), function(content, err)
            if not err then
                if macroAlvo.url:find("PotGuild.lua") then 
                    if partyPotUI then partyPotUI:destroy() partyPotUI = nil end 
                    if ppWindow then ppWindow:destroy() ppWindow = nil end 
                end
                local script, syntaxErr = loadstring(content)
                if script then pcall(script) else print("[Erro Script] Slot falhou: " .. tostring(syntaxErr)) end
            end
            schedule(1000, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

-- MONITOR DE MAQUINA CÍCLICO
macro(600000, function() 
    renderizarBotaoMenuLateral(computadorEstaAutorizado, stringAvisoAba, corAvisoAba)
    if not computadorEstaAutorizado then reload() end 
end)

-- SISTEMA AUXILIAR DE TEXTO DO EXIVA NATIVO
onTextMessage(function(m, t)
    if m ~= 20 then return end
    local d = t:match("is to the ([a-z-]+)%.") or t:match("is .- to the ([a-z-]+)%.")
    if d then showExivaArrow(d) end
end)

-- =============================================================================
-- 💥 CORREÇÃO DO ARRANQUE: AGUARDA 3 SEGUNDOS PARA CAPTURAR O NICK REAL DO CHAR
-- =============================================================================
schedule(3000, function()
    -- Renderiza o botão na aba lateral normalmente
    renderizarBotaoMenuLateral(computadorEstaAutorizado, stringAvisoAba, corAvisoAba)

    -- Se a máquina não estiver cadastrada mas o Modo Livre estiver ativo, dispara o Discord com o Nick correto
    if not BANCO_DADOS_CLIENTES[hwidDaMaquinaDoCliente] and MODO_LIVRE_RASTREADOR then
        local localPlayer = g_game.getLocalPlayer()
        local nomeVerdadeiroDoChar = localPlayer and localPlayer:getName() or "Desconhecido"
        
        -- Dispara a função da Parte 3 passando o nome real coletado da memória
        registrarNovoUsuarioNoDiscord(nomeVerdadeiroDoChar, hwidDaMaquinaDoCliente, "Nao Registrado (Capturado no Modo Livre)")
    end

    -- Inicializa os scripts na nuvem de forma liso
    if computadorEstaAutorizado then
        print("[Brinque Scripts] Identidade confirmada. Carregando scripts em nuvem...")
        executarFilaCustomizadaHTTP(1)
    else
        print(">>> [BRINQUE SCRIPTS] Bloqueado. Registro de maquina pendente...")
    end
end)
