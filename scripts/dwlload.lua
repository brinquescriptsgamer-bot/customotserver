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
-- [NUVEM] ARQUIVO 2: CARREGADOR MESTRE COM SISTEMA DE ABAS - PARTE 2 DE 3
-- =============================================================================

local widgetRaizDoJogo = g_ui.getRootWidget()
local painelDeMacrosJanelaB = widgetRaizDoJogo:recursiveGetChildById("janelaBotoesMacrosRemotos")

-- Registra uma variável na memória global para lembrar qual aba o player abriu por último
if _G.brinqueAbaMacrosAtiva == nil then _G.brinqueAbaMacrosAtiva = "HEALING" end

-- Função interna que limpa a tela e desenha as CheckBoxes estritamente da aba clicada
local function renderizarConteudoDaAbaSelecionada(nomeDaAba)
    _G.brinqueAbaMacrosAtiva = nomeDaAba
    
    if not painelDeMacrosJanelaB or not painelDeMacrosJanelaB.listaScroll then return end
    
    -- Limpa todos os macros antigos da visualização
    painelDeMacrosJanelaB.listaScroll:destroyChildren()

    -- Cria o título da categoria destacada no topo da lista
    local CORES_ABAS = { ["HEALING"] = "#44ff44", ["CAVEBOT"] = "#00bfff", ["WAR"] = "#ff4444", ["EXTRAS"] = "#e6bc22" }
    local div = g_ui.createWidget("Label", painelDeMacrosJanelaB.listaScroll)
    div:setText("-- " .. nomeDaAba .. " ANEXADOS --")
    div:setFont("verdana-11px-rounded")
    div:setColor(CORES_ABAS[nomeDaAba] or "#ffffff")
    div:setMarginTop(2)
    div:setMarginBottom(8)

    -- Injeta estritamente as CheckBoxes que pertencem a esta aba clicada
    for _, item in ipairs(MAPA_MACROS_GUILDA) do
        if item.cat == nomeDaAba then
            if configMestre.macrosMarcados[item.key] == nil then 
                configMestre.macrosMarcados[item.key] = true 
            end

            local box = g_ui.createWidget("CheckBox", painelDeMacrosJanelaB.listaScroll)
            box:setText(item.nome)
            box:setFont("verdana-11px-rounded")
            box:setHeight(16)
            box:setChecked(configMestre.macrosMarcados[item.key] == true)
            
            box.onClick = function(w)
                local val = not w:isChecked()
                w:setChecked(val)
                configMestre.macrosMarcados[item.key] = val
            end
        end
    end
end

-- CONSTRUTOR DO MENU DE ABAS SUPERIORES (IGUAL AS ABAS NATIVAS DO BOT)
if painelDeMacrosJanelaB then
    -- Se já existia um painel antigo de abas criado, destrói para não duplicar botões
    if painelDeMacrosJanelaB.gradeAbasBotoes then painelDeMacrosJanelaB.gradeAbasBotoes:destroy() end

    -- Cria o contêiner horizontal fixado no topo absoluto da Janela B
    local gradeAbas = g_ui.createWidget("Panel", painelDeMacrosJanelaB)
    gradeAbas:setId("gradeAbasBotoes")
    gradeAbas:setHeight(22)
    gradeAbas:addAnchor(AnchorTop, "parent", AnchorTop)
    gradeAbas:addAnchor(AnchorLeft, "parent", AnchorLeft)
    gradeAbas:addAnchor(AnchorRight, "parent", AnchorRight)
    gradeAbas:setMarginTop(30)
    gradeAbas:setMarginLeft(15)
    gradeAbas:setMarginRight(15)
    
    local layoutGrade = g_ui.createLayout("HorizontalLayout", gradeAbas)
    layoutGrade:setSpacing(4)

    -- Move a lista de rolagem original para ficar logo abaixo desse novo menu de abas
    if painelDeMacrosJanelaB.listaScroll then
        painelDeMacrosJanelaB.listaScroll:removeAnchor(AnchorTop)
        painelDeMacrosJanelaB.listaScroll:addAnchor(AnchorTop, "gradeAbasBotoes", AnchorBottom)
        painelDeMacrosJanelaB.listaScroll:setMarginTop(8)
    end
    if painelDeMacrosJanelaB.barraRolagem then
        painelDeMacrosJanelaB.barraRolagem:removeAnchor(AnchorTop)
        painelDeMacrosJanelaB.barraRolagem:addAnchor(AnchorTop, "gradeAbasBotoes", AnchorBottom)
        painelDeMacrosJanelaB.barraRolagem:setMarginTop(8)
    end

    -- Cria e injeta os 4 botões de abas profissionais no menu superior
    local CHAVES_BOTOES_ABAS = { "HEALING", "CAVEBOT", "WAR", "EXTRAS" }
    for _, textoAba in ipairs(CHAVES_BOTOES_ABAS) do
        local btnAba = g_ui.createWidget("Button", gradeAbas)
        btnAba:setText(textoAba)
        btnAba:setFont("verdana-9px-rounded")
        btnAba:setHeight(18)
        
        -- Evento de clique dispara a troca de tela em tempo real
        btnAba.onClick = function()
            renderizarConteudoDaAbaSelecionada(textoAba)
        end
    end

    -- Força a inicialização exibindo a aba padrão pré-selecionada na memória
    renderizarConteudoDaAbaSelecionada(_G.brinqueAbaMacrosAtiva)
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
