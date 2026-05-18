import { useBackend, useLocalState } from '../backend';
import {
  Button,
  Input,
  Section,
  Tabs,
  Table,
  LabeledList,
  Collapsible,
  Divider,
} from '../components';

import { resolveAsset } from '../assets';
import { Window } from '../layouts';
import { createSearch, decodeHtmlEntities } from 'common/string';
import { logger } from '../logging';

const findShipByRef = (ship_list, ship_ref) => {
  for (let i = 0; i < ship_list.length; i++) {
    if (ship_list[i].ref === ship_ref) return ship_list[i];
  }
  return null;
};

export const ShipSelect = (props, context) => {
  const { act, data } = useBackend(context);

  // Safety checks for data
  if (!data) {
    return (
      <Window title="Ship Select" width={800} height={600} resizable>
        <Window.Content scrollable>Loading...</Window.Content>
      </Window>
    );
  }

  const ships = data.ships || {};
  const templates = Array.isArray(data.templates) ? data.templates : [];

  const [currentTab, setCurrentTab] = useLocalState(context, 'tab', 1);
  const [selectedShipRef, setSelectedShipRef] = useLocalState(
    context,
    'selectedShipRef',
    null
  );

  const selectedShip = findShipByRef(ships, selectedShipRef);

  const applyStates = {
    open: 'Open',
    apply: 'Apply',
    closed: 'Locked',
  };

  const [shownTabs, setShownTabs] = useLocalState(context, 'tabs', [
    { name: 'Ship Select', tab: 1 },
    { name: 'Ship Purchase', tab: 3 },
  ]);

  const [searchText, setSearchText] = useLocalState(context, 'searchText', '');
  const [selectedFaction, setSelectedFaction] = useLocalState(
    context,
    'selectedFaction',
    null
  );

  // Faction sorting order - groups parent factions with their sub-factions
  const factionSortOrder = {
    'Independent': 100,
    'Confederated League of Independent Planets': 50,
    'Inteq Risk Management Group': 45,
    'Saint-Roumain Militia': 40,
    'Pan-Gezena Federation': 35,
    'Solar Confederation': 30,
    'Syndicate Coalition': 25,
    'New Gorlex Republic': 24,
    'Cybersun Industries': 23,
    'Gorlex Hardliners': 22,
    'Student-Union of Naturalistic Sciences': 21,
    'Sentient Engine Liberation Front': 20,
    'Nanotrasen': 15,
    'N+S Logistics': 14,
    'Vigilitas Interstellar': 13,
    'Frontiersmen Fleet': 5,
    'Ramzi Clique': 4,
  };

  // Sub-factions for visual grouping
  const subFactions = new Set([
    'New Gorlex Republic',
    'Cybersun Industries',
    'Gorlex Hardliners',
    'Student-Union of Naturalistic Sciences',
    'Sentient Engine Liberation Front',
    'N+S Logistics',
    'Vigilitas Interstellar',
  ]);

  // Extract unique factions from templates
  const allFactionValues = templates.map((template) => template?.faction);
  const filteredFactions = allFactionValues.filter((f) => f);
  const uniqueFactionSet = new Set(filteredFactions);
  const factionsArray = Array.from(uniqueFactionSet);

  // Sort factions by custom order, then alphabetically for unknowns
  const factions = factionsArray.sort((a, b) => {
    const orderA = factionSortOrder[a] ?? 0;
    const orderB = factionSortOrder[b] ?? 0;
    if (orderA !== orderB) {
      return orderB - orderA; // Higher numbers first
    }
    return a.localeCompare(b); // Alphabetical fallback
  });

  // Safe search function
  const searchFor = (searchText) => {
    if (!searchText) return () => true;
    const searchFn = createSearch(searchText, (thing) => thing?.name || '');
    return (thing) => {
      try {
        return searchFn(thing);
      } catch (e) {
        return false;
      }
    };
  };

  return (
    <Window title="Ship Select" width={800} height={600} resizable>
      <Window.Content scrollable>
        <Tabs>
          {shownTabs.map((tabbing, index) => (
            <Tabs.Tab
              key={`${index}-${tabbing.name}`}
              selected={currentTab === tabbing.tab}
              onClick={() => setCurrentTab(tabbing.tab)}
            >
              {tabbing.name}
            </Tabs.Tab>
          ))}
        </Tabs>
        {currentTab === 1 && (
          <Section
            title="Active Ship Selection"
            buttons={
              <>
                <Button
                  content="Purchase Ship"
                  tooltip={
                    /* worth noting that disabled ship spawn doesn't cause the
                  button to be disabled, as we want to let people look around */
                    (data.purchaseBanned &&
                      'You are banned from purchasing ships.') ||
                    (!data.shipSpawnAllowed &&
                      'No more ships may be spawned at this time.') ||
                    (data.shipSpawning &&
                      'A ship is currently spawning. Please wait.')
                  }
                  disabled={data.purchaseBanned}
                  onClick={() => {
                    setCurrentTab(3);
                  }}
                />
                <Button
                  content="?"
                  tooltip={"Hover over a ship's name to see its faction."}
                />
              </>
            }
          >
            <Table>
              <Table.Row header>
                <Table.Cell collapsing>Join</Table.Cell>
                <Table.Cell>Ship Name</Table.Cell>
                <Table.Cell>Ship Class</Table.Cell>
              </Table.Row>
              {Object.values(ships).map((ship) => {
                const shipName = decodeHtmlEntities(ship.name);
                const shipFaction = ship.faction;
                return (
                  <Table.Row key={shipName}>
                    <Table.Cell>
                      <Button
                        content={
                          ship.joinMode === applyStates.apply ? 'Apply' : 'Join'
                        }
                        color={
                          ship.joinMode === applyStates.apply
                            ? 'average'
                            : 'good'
                        }
                        onClick={() => {
                          setSelectedShipRef(ship.ref);
                          setCurrentTab(2);
                          const newTab = {
                            name: 'Job Select',
                            tab: 2,
                          };
                          // check if the tab already exists
                          const tabExists = shownTabs.some(
                            (tab) =>
                              tab.name === newTab.name && tab.tab === newTab.tab
                          );
                          if (tabExists) {
                            return;
                          }
                          setShownTabs((tabs) => {
                            logger.log(tabs);
                            const newTabs = [...tabs];
                            newTabs.splice(1, 0, newTab);
                            return newTabs;
                          });
                        }}
                      />
                    </Table.Cell>
                    <Table.Cell title={shipFaction}>{shipName}</Table.Cell>
                    <Table.Cell>{ship.class}</Table.Cell>
                  </Table.Row>
                );
              })}
            </Table>
          </Section>
        )}
        {currentTab === 2 && (
          <>
            <Section
              title={`Ship Details - ${decodeHtmlEntities(selectedShip.name)}`}
            >
              <LabeledList>
                <LabeledList.Item label="Ship Class">
                  {selectedShip.class}
                </LabeledList.Item>
                <LabeledList.Item label="Ship Faction">
                  {selectedShip.faction}
                </LabeledList.Item>
                <LabeledList.Item label="Ship Join Status">
                  {selectedShip.joinMode}
                </LabeledList.Item>
                <LabeledList.Item label="Ship Memo">
                  {decodeHtmlEntities(selectedShip.memo) || 'No Memo'}
                </LabeledList.Item>
              </LabeledList>
            </Section>
            <Collapsible title={'Ship Info'}>
              <LabeledList>
                <LabeledList.Item label="Ship Description">
                  {selectedShip.desc || 'No Description'}
                </LabeledList.Item>
                <LabeledList.Item label="Ship Tags">
                  {(selectedShip.tags && selectedShip.tags.join(', ')) ||
                    'No Tags Set'}
                </LabeledList.Item>
              </LabeledList>
            </Collapsible>
            <Section
              title="Job Selection"
              buttons={
                <Button
                  content="Back"
                  onClick={() => {
                    setCurrentTab(1);
                  }}
                />
              }
            >
              <Table>
                <Table.Row header>
                  <Table.Cell collapsing>Join</Table.Cell>
                  <Table.Cell>Job Name</Table.Cell>
                  <Table.Cell>Slots</Table.Cell>
                  <Table.Cell>Min. Playtime</Table.Cell>
                </Table.Row>
                {selectedShip.jobs.map((job) => (
                  <Table.Row key={job.name}>
                    <Table.Cell>
                      <Button
                        content="Select"
                        tooltip={
                          (!data.autoMeet &&
                            data.playMin < job.minTime &&
                            'You do not have enough playtime to play this job.') ||
                          (data.officerBanned &&
                            'You are banned from playing officer roles')
                        }
                        disabled={
                          (!data.autoMeet && data.playMin < job.minTime) ||
                          (data.officerBanned && job.officer)
                        }
                        onClick={() => {
                          act('join', {
                            ship: selectedShip.ref,
                            job: job.ref,
                          });
                        }}
                      />
                    </Table.Cell>
                    <Table.Cell>{job.name}</Table.Cell>
                    <Table.Cell>{job.slots}</Table.Cell>
                    <Table.Cell>
                      {formatShipTime(job.minTime, data.playMin, data.autoMeet)}
                    </Table.Cell>
                  </Table.Row>
                ))}
              </Table>
            </Section>
          </>
        )}
        {currentTab === 3 && (
          <>
            <Section
              title="Ship Purchase"
              buttons={
                <>
                  <Input
                    placeholder="Search..."
                    autoFocus
                    value={searchText}
                    onInput={(_, value) => setSearchText(value)}
                  />
                  <Button
                    content="Back"
                    onClick={() => {
                      setCurrentTab(1);
                    }}
                  />
                </>
              }
            />
            <div style={{ display: 'flex', gap: '0.5em' }}>
              <Section
                title="Factions"
                style={{ flex: '0 0 200px', minWidth: '200px' }}
              >
                <Button
                  fluid
                  content="All Factions"
                  color={selectedFaction === null ? 'good' : 'default'}
                  onClick={() => setSelectedFaction(null)}
                />
                {factions.length > 0 ? (
                  factions.map((faction) => {
                    const isSubFaction = subFactions.has(faction);
                    return (
                      <Button
                        key={faction}
                        fluid
                        content={isSubFaction ? `  ↳ ${faction}` : faction}
                        color={selectedFaction === faction ? 'good' : 'default'}
                        onClick={() => setSelectedFaction(faction)}
                        style={
                          isSubFaction
                            ? { textAlign: 'left', paddingLeft: '0.5em' }
                            : {}
                        }
                      />
                    );
                  })
                ) : (
                  <div style={{ padding: '0.5em', color: '#888' }}>
                    No factions found
                  </div>
                )}
              </Section>
              <Section
                title={
                  selectedFaction
                    ? `${selectedFaction} Ships`
                    : 'All Available Ships'
                }
                style={{ flex: '1', minWidth: 0, overflowY: 'auto' }}
              >
                {templates.length > 0 ? (
                  templates
                    .filter((template) => {
                      if (!template) return false;
                      if (!searchText) return true;
                      const searchFn = searchFor(searchText);
                      return searchFn(template);
                    })
                    .filter(
                      (template) =>
                        template &&
                        (selectedFaction === null ||
                          template?.faction === selectedFaction)
                    )
                    .map((template) => {
                      if (!template) return null;
                      return (
                        <Collapsible
                          title={template.name}
                          key={template.name}
                          color={
                            (!data.shipSpawnAllowed && 'average') ||
                            ((template.curNum >= template.limit ||
                              (!data.autoMeet &&
                                data.playMin < template.minTime)) &&
                              'grey') ||
                            'default'
                          }
                          buttons={
                            <Button
                              content="Buy"
                              tooltip={
                                (!data.shipSpawnAllowed &&
                                  'No more ships may be spawned at this time.') ||
                                (template.curNum >= template.limit &&
                                  'There are too many ships of this type.') ||
                                (!data.autoMeet &&
                                  data.playMin < template.minTime &&
                                  'You do not have enough playtime to buy this ship.') ||
                                (data.shipSpawning &&
                                  'A ship is currently spawning. Please wait.')
                              }
                              disabled={
                                !data.shipSpawnAllowed ||
                                data.shipSpawning ||
                                template.curNum >= template.limit ||
                                (!data.autoMeet &&
                                  data.playMin < template.minTime)
                              }
                              onClick={() => {
                                act('buy', {
                                  name: template.name,
                                });
                              }}
                            />
                          }
                        >
                          <LabeledList>
                            <LabeledList.Item label="Description">
                              {template.desc || 'No Description'}
                            </LabeledList.Item>
                            <LabeledList.Item label="Ship Faction">
                              {template.faction}
                            </LabeledList.Item>
                            <LabeledList.Item label="Ship Tags">
                              {(template.tags && template.tags.join(', ')) ||
                                'No Tags Set'}
                            </LabeledList.Item>
                            <LabeledList.Item label="Std. Crew">
                              {template.crewCount}
                            </LabeledList.Item>
                            <LabeledList.Item label="Max #">
                              {template.limit}
                            </LabeledList.Item>
                            <LabeledList.Item label="Min. Playtime">
                              {formatShipTime(
                                template.minTime,
                                data.playMin,
                                data.autoMeet
                              )}
                            </LabeledList.Item>
                            {/*
                  <LabeledList.Item label="Wiki Link">
                    <a
                      href={'https://shiptest.net/wiki/' + template.name}
                      target="_blank"
                      rel="noreferrer"
                    >
                      Here
                    </a>
                  </LabeledList.Item>*/}
                            <LabeledList.Item label="Lead Architect">
                              {template.architect || 'Unknown Architect'}
                            </LabeledList.Item>
                            <LabeledList.Item label="Contributors">
                              {(template.contributors &&
                                template.contributors.join(', ')) ||
                                'Unknown Contributors'}
                            </LabeledList.Item>
                          </LabeledList>
                          <Collapsible
                            title={
                              'Ship Image (Click image to open in browser for finer detail)'
                            }
                            key={template.name + ' Image'}
                          >
                            <img
                              src={
                                template.shortName
                                  ? resolveAsset(template.shortName)
                                  : ''
                              }
                              width={'100%'}
                              style={{ cursor: 'pointer' }}
                              onClick={() => {
                                if (template.shortName) {
                                  const url = resolveAsset(template.shortName);
                                  window.open(url, '_blank');
                                }
                              }}
                            />
                          </Collapsible>
                          <Divider horizontal />
                        </Collapsible>
                      );
                    })
                ) : (
                  <div>No ships available</div>
                )}
              </Section>
            </div>
          </>
        )}
      </Window.Content>
    </Window>
  );
};

const formatShipTime = (minTime, playMin, autoMeet) => {
  return (
    (minTime <= 0 && '-') ||
    minTime + 'm ' + ((!autoMeet && playMin < minTime && '(Unmet)') || '(Met)')
  );
};
