-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE COM SISTEMA DE ABAS - PARTE 1 DE 3
-- =============================================================================

local panelNameMestre = "painelBrinqueMultiServidores"
if not storage[panelNameMestre] then storage[panelNameMestre] = {} end
local configMestre = storage[panelNameMestre]

local servidorAtivoNoMomento = configMestre.servidorSelecionado or "Ilusion"

-- Links base apontando diretamente para a raiz da sua estrutura de pastas do GitHub
local URL_BASE_REPOSITORIO = "https://raw.githubusercontent.com/brinquescriptsgamer-bot/customotserver/refs/heads/main/scripts/"

-- 📂 MAPEAMENTO EXATO DE SUBPASTAS DO SEU REPOSITÓRIO
local SCRIPTS_DO_REPOSITORIO = {
    ["Ilusion"] = {
        { nome = "HEALING BRQ ILUSION",     key = "healingBRQ",       cat = "HEALING",     url = URL_BASE_REPOSITORIO .. "sv_ilusion/healing/healingBRQ.lua" },
        { nome = "CAVEBOT COMPLETO ILU",    key = "cavebotILU",       cat = "CAVEBOT",     url = URL_BASE_REPOSITORIO .. "sv_ilusion/cavebot/cavebotILU.lua" },
        { nome = "MAGIAS S/PK BRQ ILUSION",  key = "magiasempkBRQ",    cat = "WAR",         url = URL_BASE_REPOSITORIO .. "sv_ilusion/war/magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS ILU",   key = "extrasILU",        cat = "EXTRAS",      url = URL_BASE_REPOSITORIO .. "sv_ilusion/extras/extrasILU.lua" }
    },
    ["Minimalist"] = {
        { nome = "HEALING BRQ MINIMALIST",   key = "healingMIN",       cat = "HEALING",     url = URL_BASE_REPOSITORIO .. "sv_minimalist/healing/healingMIN.lua" },
        { nome = "CAVEBOT COMPLETO MIN",    key = "cavebotMIN",       cat = "CAVEBOT",     url = URL_BASE_REPOSITORIO .. "sv_minimalist/cavebot/cavebotMIN.lua" },
        { nome = "FILTRO BATTLE BRQ",       key = "filtroBattle",     cat = "WAR",         url = URL_BASE_REPOSITORIO .. "sv_minimalist/war/Filtrobattle.lua" },
        { nome = "EXTRAS ESSENCIAIS MIN",   key = "extrasMIN",        cat = "EXTRAS",      url = URL_BASE_REPOSITORIO .. "sv_minimalist/extras/extrasMIN.lua" }
    },
    ["Legedy"] = {
        { nome = "HEALING BRQ LEGEDY",      key = "healingLEG",       cat = "HEALING",     url = URL_BASE_REPOSITORIO .. "sv_legend/healing/healingLEG.lua" },
        { nome = "CAVEBOT COMPLETO LEG",    key = "cavebotLEG",       cat = "CAVEBOT",     url = URL_BASE_REPOSITORIO .. "sv_legend/cavebot/cavebotLEG.lua" },
        { nome = "WAR LEGEDY COMBAT",        key = "magiasempkLEG",    cat = "WAR",         url = URL_BASE_REPOSITORIO .. "sv_legend/war/magiasempkBRQ.lua" },
        { nome = "EXTRAS ESSENCIAIS LEG",   key = "extrasLEG",        cat = "EXTRAS",      url = URL_BASE_REPOSITORIO .. "sv_legend/extras/extrasLEG.lua" }
    }
}

local MAPA_MACROS_GUILDA = SCRIPTS_DO_REPOSITORIO[servidorAtivoNoMomento] or {}
-- =============================================================================
-- [PAINEL CENTRAL - PARTE 2 DE 4] STRINGS OTUI COM DUAS JANELAS RECALIBRADAS
-- =============================================================================
local widgetRaizDoJogo = g_ui.getRootWidget()

-- JANELA A: SELEÇÃO DE SERVIDORES E STATUS DA CONTA
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
"    image-source: /bot/Vs3_CUSTOM_PREMIUM/imagens/logobrinque.png\n" ..
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
"    image-source: /bot/Vs3_CUSTOM_PREMIUM/imagens/botao_dourado.png\n" ..
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
"    image-source: /bot/Vs3_CUSTOM_PREMIUM/imagens/botao_dourado.png\n" ..
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

-- JANELA B: CALIBRADA E EXPANDIDA PARA ENCAIXAR AS ABAS SUPERIORES PERFEITAMENTE
local designMacrosOTUI = "MainWindow\n" ..
"  id: janelaBotoesMacrosRemotos\n" ..
"  size: 340 460\n" ..
"  text: Macros Ativos - Brinque\n" ..
"  @onEscape: self:hide()\n" ..
"  background-color: alpha\n" ..
"  image-border: 0\n" ..
"  border: 0 alpha\n" ..
"  padding: 0\n" ..
"  layout: anchor\n" ..
"\n" ..
"  UIWidget\n" ..
"    id: imgFundoMacros\n" ..
"    image-source: /bot/Vs3_CUSTOM_PREMIUM/imagens/llogobrinque.png\n" ..
"    image-smooth: true\n" ..
"    image-fixed-ratio: false\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  Panel\n" ..
"    background-color: #00000065\n" ..
"    anchors.fill: parent\n" ..
"    margin: -5\n" ..
"    phantom: true\n" ..
"\n" ..
"  ScrollablePanel\n" ..
"    id: listaScroll\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.left: parent.left\n" ..
"    anchors.right: barraRolagem.left\n" ..
"    anchors.bottom: closeBtnMacros.top\n" ..
"    margin-top: 65\n" ..
"    margin-left: 20\n" ..
"    margin-right: 2\n" ..
"    margin-bottom: 15\n" ..
"    vertical-scrollbar: barraRolagem\n" ..
"    layout:\n" ..
"      type: verticalBox\n" ..
"      spacing: 6\n" ..
"\n" ..
"  VerticalScrollBar\n" ..
"    id: barraRolagem\n" ..
"    anchors.top: parent.top\n" ..
"    anchors.bottom: closeBtnMacros.top\n" ..
"    anchors.right: parent.right\n" ..
"    margin-top: 65\n" ..
"    margin-bottom: 15\n" ..
"    margin-right: 12\n" ..
"    step: 20\n" ..
"    pixels-scroll: true\n" ..
"\n" ..
"  Button\n" ..
"    id: closeBtnMacros\n" ..
"    text: Ocultar\n" ..
"    font: cipsoftFont\n" ..
"    anchors.right: parent.right\n" ..
"    anchors.bottom: parent.bottom\n" ..
"    size: 60 20\n" ..
"    margin-bottom: 10\n" ..
"    margin-right: 20\n" ..
"    @onClick: self:getParent():hide()\n"

if widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros") then widgetRaizDoJogo:recursiveGetChildById("janelaEscolhaMacros"):destroy() end
if widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos") then widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos"):destroy() end

local setupMacrosWindow = setupUI(designPrincipalOTUI, widgetRaizDoJogo)
setupJanelaBotoesMacros = setupUI(designMacrosOTUI, widgetRaizDoJogo)

setupMacrosWindow:hide()
setupJanelaBotoesMacros:hide()

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

local mapeamentoBotoesImagens = {
    { widget = setupMacrosWindow.imgFundoInsta,   file = "botao_dourado.png" },
    { widget = setupMacrosWindow.imgFundoWhats,   file = "botao_dourado.png" }
}
for _, itemBtn in ipairs(mapeamentoBotoesImagens) do
    if not g_resources.fileExists(pastaImg .. itemBtn.file) then
        itemBtn.widget:setImageSource("")
        itemBtn.widget:setBackgroundColor("#2f2f2f")
    end
end

-- =============================================================================
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE COM SISTEMA DE ABAS - PARTE 3 DE 3
-- =============================================================================

-- ESTEIRA HTTP DE INJEÇÃO EM MEMÓRIA (BAIXA APENAS OS SCRIPTS SELECIONADOS)
local loteJaEstaSendoBaixado = false

local function executarFilaCustomizadaHTTP(indice)
    -- Cruza a permissao global herdada do validador principal (new_items.lua)
    if not computadorEstaAutorizado then 
        print("[Seguranca] Sessao nao autorizada. Download de macros abortado.")
        return 
    end
    
    if indice == 1 then 
        if loteJaEstaSendoBaixado then return end 
        loteJaEstaSendoBaixado = true 
    end
    
    local macroAlvo = MAPA_MACROS_GUILDA[indice]
    if not macroAlvo then 
        print("[Brinque Scripts] Sincronizacao de macros concluida para as abas do servidor.")
        loteJaEstaSendoBaixado = false 
        return 
    end
    
    -- Checa se a CheckBox desse macro específico está marcada na memória do painel
    if configMestre.macrosMarcados[macroAlvo.key] == true then
        -- Injeta a quebra de cache para o client baixar o script sempre atualizado do GitHub
        HTTP.get(macroAlvo.url .. "?nocache=" .. os.time(), function(content, err)
            if not err and content and content ~= "" then
                local script, syntaxErr = loadstring(content)
                if script then 
                    pcall(script) 
                else 
                    print("[Erro Script] Falha ao compilar slot: " .. tostring(macroAlvo.nome) .. " - Erro: " .. tostring(syntaxErr)) 
                end
            end
            -- VELOCIDADE PERFORMANCE: Dispara o próximo macro da fila após 200ms
            schedule(200, function() executarFilaCustomizadaHTTP(indice + 1) end)
        end)
    else
        -- Se estiver desmarcado, pula imediatamente para o próximo
        executarFilaCustomizadaHTTP(indice + 1)
    end
end

-- =============================================================================
-- GATILHO DE ARRANCADA DO COMPILADOR EM NUVEM (TIMEOUT SEGURO DE 300MS)
-- =============================================================================
schedule(300, function()
    if computadorEstaAutorizado then
        print("[Brinque] Processando download em esteira das abas de: " .. tostring(servidorAtivoNoMomento))
        executarFilaCustomizadaHTTP(1)
    else
        -- Proteção contra invasores: Se tentar forçar, limpa a Janela B na marra
        if painelDeMacrosJanelaB and painelDeMacrosJanelaB.listaScroll then
            painelDeMacrosJanelaB.listaScroll:destroyChildren()
        end
    end
end)
